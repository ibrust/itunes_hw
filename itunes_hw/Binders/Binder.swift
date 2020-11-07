//
//  Binder.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit



class Binder {
    
    var request_manager: RequestManager
    
    var gotten_song: SingleSong? = nil
    
    
    // this is called by an observer of the model when the model updates
    // it'll need to be passed an integer from the model somehow...
    // the integer is the row that will be updated in the table
    // the bound function will have access to the tableviews data - and thus the cell data through the integer, and also the model data through the intent functions (these are called within the closure)
    // note that this accesses the cells data and sets them to the intent functions of the binder (which simply return the data). this is all after the binder has been alerted of changes via the observer (which calls this)
    var bound_cellupdatehandler: ((Int) -> ())? = nil
    
    init(request_manager: RequestManager = RequestManager()){
        self.request_manager = request_manager
        /*let url = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"
        self.request_manager.fetch_json_list(url, completion: {print("complete");return})*/
    }
    
    
    func bind_cellupdatehandler(update_handler: @escaping (Int) -> ()){
        self.bound_cellupdatehandler = update_handler
        
        
        /*
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil,
            queue: nil) { (notification) in
        
            // so you probably want to loop through all the notification objects, whatever they are, and get the row... along with the changes. but for now let's just continue and test this, and see if it even does anything...
            guard let user_info = notification.userInfo else {return}
            
            /*
            print("in observer, calling bound_cellupdatehandler(1) with notification: ", notification)
            print("user info: ", user_info)*/
            
            /*if let inserts = user_info[NSInsertedObjectsKey] as? Set<NSManagedObject> where inserts.count > 0 {
                
            }*/
        
            //self.bound_cellupdatehandler?(1)
        }*/
        
    }
    
    // you want to add an observer to the binder... how?
    
    
}


extension Binder{
    func get_image(_ row: Int){
        
    }
    func get_song_data(_ row: Int){
        self.gotten_song = self.request_manager.get_song_data(row)
    }
}

