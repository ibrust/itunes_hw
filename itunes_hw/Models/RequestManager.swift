//
//  RequestManager.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData


class RequestManager{
    
    var session: URLSession
    var decoder: JSONDecoder
    var app_delegate = AppDelegate()
    var operations_queue = OperationQueue()
    var fetch_operation: Fetch_List_Operation? = nil
    
    init(){
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = AppDelegate.persistentContainer.viewContext
        self.session = URLSession.shared
        self.fetch_operation = Fetch_List_Operation(self)
    }
    
    // you could use an operation to fetch the image...?
    // I don't think there's a downside to fetching the image from the database multiple times, but you are going to have to request this image somewhere.
    // that might benefit from an operation
    func fetch_image(){
        
    }
    
    func get_image(){
        
    }
        
    // should you use operations to fetch the song...?
    // there's no real downside to repeatedly fetching the song, assuming it's there.
    // what you really need is a way of knowing if the database is full or not.
    
    // cellforrowat is calling a function, but your model is automatically updating, correct?
    // so I believe this function actually triggers the handler.
    // the return of this function is what is detected by didset...
    func get_song_data(_ row: Int) -> SingleSong {
        let context = AppDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
        request.predicate = NSPredicate(format: "unique_id = %@", String(row))
        
        do{
            let results = try context.fetch(request)
            print("FETCHED RESULTS: ", results)
            if results == [] {
                print("it's []")
                // maybe do a fetch json operation here?
            }
            if let single_song = results.first {
                return single_song
            }
        } catch {
            print("ERROR FETCHING RESULTS", error)
        }
        
        return SingleSong()
    }
    
    func delete_song_data(_ row: Int){
        
    }
    
    
    // so... I think this will fetch the data if it's required, and will be called once...
    // but lets say the data is already in the database.
    // dont you need to return the data then? you can't rely on notifications if nothing changes...
    // you could just do nothing if it's already there, and manage that elsewhere.

    // do you need a custom notification for the database call, in the event the json is already there, then? Because the data isn't always gona change.

    
    
}

class Fetch_List_Operation: Operation {
    let url = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
    
    var request_manager: RequestManager
    
    init(_ request_manager: RequestManager){
        self.request_manager = request_manager
    }
    
    override func main(){
        fetch_json_list() { [weak self] in ()
            guard let self = self else {return}
            DispatchQueue.main.async {

                /*
                self.table_controller_reference?.tableView.reloadData()
                for index in 0..<100) {
                    if index < max_pokemon {
                        fetch_pokemon_operations[index] = Fetch_Pokemon_Operation(index, self.table_controller_reference)
                        operations_queue.addOperation(fetch_pokemon_operations[index]!)
                    }
                }*/
            }
        }
    }
    

    func fetch_json_list(completion: @escaping () -> () ){
        guard let url_obj = URL(string: url) else {print("url issue");return}
        self.request_manager.session.dataTask(with: url_obj) { (data, response, error) in
            if let _ = error {print(error);return}
            guard let data = data else {return}
            do {
                let json_struct = try self.request_manager.decoder.decode(JSON_struct.self, from: data)
                                
                } catch let json_error {print("error decoding json in fetch_json_list: ", json_error)}
            self.request_manager.app_delegate.saveContext()
            
        }.resume()
    }
    
}

