//
//  RequestManager.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import Foundation


class RequestManager{
    
    
    func fetch_song(_ row: Int) -> SingleSong {
        
        // here you need that logic to make a fetch from the database,
        // then optionally fetch the json... etc.
        // at some point you're gona have to fetch the image also ...
        // you could use an operation to fetch the image...?
        // the json you're just fetching all at once, so...
        
        // though I kind of just want to fetch the json first...
        // but remember the application runs repeatedly
        
        
        // shouldn't something be called at the very beginning of the application?
        // should it be called in here....?
        // this is just gona be a database call...?
        // how would you synchronize it with the core data call then...?
        // the automatic updating.......? how does that work exactly?
        // cellforrowat is calling a function, but your model is automatically updating, correct?
        // so how the hell is that working?
        // so I believe this function actually triggers the handler.
        // the return of this function is what is detected by didset...
        
        // you COULD put the overall network call in an operation, right?
        // but lets say this gets called and does nothing...
        // didSet is not working for this data anymore, because it's overwritten by the next request from a cell...
        // normally didSet is supposed to detect any changes...
        // you need notifications
        
        
        
        
        
        
        
        return SingleSong()
    }
    
    
    
}
