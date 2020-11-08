//
//  Binder.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData


class Binder {
    
    var request_manager: RequestManager? = nil
    
    var gotten_song: SingleSong? {
        
        // so I think that this class... being a database class, is somehow tied to the database.
        // when the database is empty... you aren't accessing a real property in the database?
        // it's not a regular property, it's a property preceded by something.
        // really you don't want this to call unless you find something.
        // if you don't find something you want to do something else... right? we will see.
        willSet {
            if newValue != nil{
                guard let single_song = newValue as? SingleSong? else {return}
                guard let unique_id = single_song?.unique_id else {return}
                print("WILLSET")
                guard let converted_id = Int(unique_id) else {return}
                songs_array[converted_id] = single_song
                bound_cellupdatehandler?(converted_id)
            }
        }
    }
    
    var songs_array = [SingleSong?](repeating: nil, count: total_rows)
    
    // this is called by an observer of the model when the model updates
    // it'll need to be passed an integer from the model somehow...
    // the integer is the row that will be updated in the table
    // the bound function will have access to the tableviews data - and thus the cell data through the integer, and also the model data through the intent functions (these are called within the closure)
    // note that this accesses the cells data and sets them to the intent functions of the binder (which simply return the data). this is all after the binder has been alerted of changes via the observer (which calls this)
    var bound_cellupdatehandler: ((Int) -> ())? = nil
    
    init(){
        self.request_manager = RequestManager()
    }
    
    func bind_cellupdatehandler(update_handler: @escaping (Int) -> ()){
        self.bound_cellupdatehandler = update_handler
    }
    
}


extension Binder{
    func get_image(_ row: Int){
        
    }
    func get_song_data(_ row: Int){
        self.gotten_song = self.request_manager?.get_song_data(row)
    }
    
    func return_song() -> SingleSong? {
        return self.gotten_song
    }
    
}

