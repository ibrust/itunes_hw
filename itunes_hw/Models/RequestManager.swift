//
//  RequestManager.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData

let total_rows = 100

class RequestManager{
    
    var session: URLSession
    var decoder: JSONDecoder
    var app_delegate = AppDelegate()
    fileprivate var operations_queue = OperationQueue()
    fileprivate var fetch_operation: Fetch_List_Operation? = nil
    
    init(){
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = AppDelegate.updateContext
        self.session = URLSession.shared
        self.fetch_operation = Fetch_List_Operation(self)
    }
    
    // use an operation to fetch the image instead of this function
    func fetch_image(){
        
    }
    
    func get_image(){
        
    }

    func get_song_data(_ row: Int) -> SingleSong? {
        let context = AppDelegate.persistentContainer.viewContext
        var single_song = SingleSong()
        let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
        request.predicate = NSPredicate(format: "unique_id = %@", String(row))

        do{
            let results = try context.fetch(request)
            if results == [] {
                if self.fetch_operation?.isFinished == false && self.fetch_operation?.isExecuting == false{
                    self.operations_queue.addOperation(self.fetch_operation!)
                }
            } else {
                if let _ = results.first {
                    single_song = results.first!
                    return single_song
                }
            }
            
        } catch {
            print("ERROR FETCHING RESULTS", error)
        }
        return nil
    }
    
    func delete_song_data(_ row: Int){
        
    }
}

fileprivate class Fetch_List_Operation: Operation {
    var request_manager: RequestManager
    let url = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    
    init(_ request_manager: RequestManager){
        self.request_manager = request_manager
    }
    
    override func main(){
        fetch_json_list()
    }

    func fetch_json_list(){
        guard let url_obj = URL(string: url) else {print("url error in fetch_json_list");return}
        
        self.request_manager.session.dataTask(with: url_obj) { (data, response, error) in
            if let _ = error {print("fetching error in fetch_json_list: ", error);return}
            guard let data = data else {return}
            
            do {
                let json_struct = try self.request_manager.decoder.decode(JSON_struct.self, from: data)
            }
            catch let json_error {print("error decoding json in fetch_json_list: ", json_error)}
        }.resume()
    }
    
}

extension Notification.Name {
    static let List_Fetch_Complete = Notification.Name("List_Fetch_Complete")
}

