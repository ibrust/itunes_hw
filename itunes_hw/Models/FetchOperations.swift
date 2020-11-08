//
//  FetchOperations.swift
//  itunes_hw
//
//  Created by Field Employee on 11/8/20.
//

import UIKit
import CoreData



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



