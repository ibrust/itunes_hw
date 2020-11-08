//
//  RequestManager.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData

let total_rows = 100
let operations_queue = OperationQueue()
var fetch_operation: Fetch_List_Operation? = nil
var image_operations = [Fetch_Image_Operation?](repeating: nil, count: total_rows)

class RequestManager{
    
    var session: URLSession
    var decoder: JSONDecoder
    var app_delegate = AppDelegate()
    
    init(){
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = AppDelegate.updateContext
        self.session = URLSession.shared
        fetch_operation = Fetch_List_Operation(self)
    }

    func get_song_data(_ row: Int) -> SingleSong? {
        let context = AppDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
        request.predicate = NSPredicate(format: "unique_id = %@", String(row))

        do{
            let results = try context.fetch(request)
            if results == [] {
                if fetch_operation?.isFinished == false && fetch_operation?.isExecuting == false {
                    operations_queue.addOperation(fetch_operation!)
                }
            } else {
                if var single_song = results.first {
                    if single_song.image_data == nil {
                        if image_operations[row] != nil && image_operations[row]?.isFinished == false && image_operations[row]?.isExecuting == false{
                            operations_queue.addOperation(image_operations[row]!)
                        }
                    }
                    
                    return single_song
                }
            }
            
        } catch {
            print("ERROR FETCHING RESULTS", error)
        }
        return nil
    }
}


// try adding this to a main operation queue of some sort if
// you continue to have context update problems

class Fetch_List_Operation: Operation {
    var request_manager: RequestManager
    let url = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    
    init(_ request_manager: RequestManager){
        self.request_manager = request_manager
        super.init()
    }
    
    override func main(){
        guard let url_obj = URL(string: url) else {print("url error in fetch_json_list");return}
        
        self.request_manager.session.dataTask(with: url_obj) { (data, response, error) in
            if let _ = error {print("fetching error in fetch_json_list: ", error);return}
            guard let data = data else {return}
            
            do {
                let json_struct = try self.request_manager.decoder.decode(JSON_struct.self, from: data)

                for (count, song) in json_struct.feed.results.enumerated() {
                    image_operations[count] = Fetch_Image_Operation(self.request_manager, song: song)
                }
                
                NotificationCenter.default.post(
                    name: Notification.Name.List_Fetch_Complete,
                    object: self)
            }
            catch let json_error {print("error decoding json in fetch_json_list: ", json_error)}
        }.resume()
    }
}

class Fetch_Image_Operation: Operation {
    
    var request_manager: RequestManager
    var song: SingleSong
    var url: String?
    
    init(_ request_manager: RequestManager, song: SingleSong){
        self.request_manager = request_manager
        self.song = song
        self.url = song.artworkUrl100
        super.init()
    }
    
    override func main(){
        guard let url = self.url else{return}
        guard let url_obj = URL(string: url) else {print("url error in fetch_json_list");return}
        
        self.request_manager.session.dataTask(with: url_obj) { [weak self] (data, response, error) in
            guard let self = self else{return}
            if let _ = error {print("fetching error in fetch_json_list: ", error);return}
            guard let data = data else {return}
            self.song.image_data = data
            
            let id: String = self.song.unique_id ?? "-1"
            let context = AppDelegate.updateContext
            let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
            request.predicate = NSPredicate(format: "unique_id = %@", id)
            
            do{
                let results = try context.fetch(request)
                if let single_song = results.first {
                    single_song.image_data = data
                    do {
                        try context.save()
                        DispatchQueue.main.async{
                            try? AppDelegate.viewContext.save()
                        }
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            } catch {return}
            
        }.resume()
    }
    
}

extension Notification.Name {
    static let List_Fetch_Complete = Notification.Name("List_Fetch_Complete")
}

