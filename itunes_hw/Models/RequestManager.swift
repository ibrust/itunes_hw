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
            }
            else {
                if let single_song = results.first {
                    if single_song.image_data == nil {
                        if image_operations[row] != nil && image_operations[row]?.isFinished == false && image_operations[row]?.isExecuting == false{
                            
                            operations_queue.addOperation(image_operations[row]!)
                        } else if image_operations[row] == nil {
                            
                            image_operations[row] = Fetch_Image_Operation(self, song: single_song)
                            operations_queue.addOperation(image_operations[row]!)
                        }
                    }
                    return single_song
                }
            }
        } catch {print("ERROR FETCHING RESULTS", error)}
        return nil
    }
    
    func toggle_song_button(_ row: Int) -> SingleSong? {
        let context = AppDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
        request.predicate = NSPredicate(format: "unique_id = %@", String(row))

        do{
            let results = try context.fetch(request)
            if results != [] {
                if let single_song = results.first {
                    single_song.star_toggle = !single_song.star_toggle
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                        } catch {
                            let nserror = error as NSError
                            print("Unresolved error \(nserror), \(nserror.userInfo)")
                        }
                    }
                    
                    return single_song
                }
            }
        } catch {print("ERROR FETCHING RESULTS", error)}
        return nil
    }
    
    func return_song(_ row: Int) -> SingleSong? {
        let context = AppDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<SingleSong> = SingleSong.fetchRequest()
        request.predicate = NSPredicate(format: "unique_id = %@", String(row))

        do{
            let results = try context.fetch(request)
            if let single_song = results.first {
                print("single song: ", single_song)
                return single_song
            }
        } catch {print("ERROR FETCHING RESULTS", error)}
        return nil
    }
    
}



