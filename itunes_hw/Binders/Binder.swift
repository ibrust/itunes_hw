//
//  Binder.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import Foundation



class Binder {
    
    var request_manager: RequestManager
    
    
    
    // this is called by an observer of the model when the model updates
    // it'll need to be passed an integer from the model somehow...
    // the integer is the row that will be updated in the table
    // the bound function will have access to the tableviews data - and thus the cell data through the integer, and also the model data through the intent functions (these are called within the closure)
    // note that this accesses the cells data and sets them to the intent functions of the binder (which simply return the data). this is all after the binder has been alerted of changes via the observer (which calls this)
    var bound_cellupdatehandler: ((Int) -> ())? = nil
    
    init(request_manager: RequestManager = RequestManager()){
        self.request_manager = request_manager
    }
    
    
    func bind_cellupdatehandler(update_handler: @escaping (Int) -> ()){
        self.bound_cellupdatehandler = update_handler
    }
    
    
}


extension Binder{
    func get_image(_ row: Int){
        
    }
    func get_song_data(_ row: Int){
        
    }
}

