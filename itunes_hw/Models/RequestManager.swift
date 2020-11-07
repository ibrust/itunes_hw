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
    
    init(){
        decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext!] = AppDelegate.persistentContainer.viewContext
        self.session = URLSession.shared
    }
        
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
        
        
        
        // honestly I don't even know if I need this, if my notification observer is working it should just fire without me having to call fetch data for the individual songs?
        // after all, I'm only fetching the json one time...
        // let me just try getting the json and see if that even works...
        
        
        // well... this will be needed for the detail, though. right?
        // you'll have to fetch specific data for the detail...
        
        
        return SingleSong()
    }
    
    
    // so... I think this will fetch the data if it's required, and will be called once...
    // but lets say the data is already in the database.
    // dont you need to return the data then? you can't rely on notifications if nothing changes...
    // you could just do nothing if it's already there, and manage that elsewhere.
    // just simply have this function fetch the json if it's needed.
    // but you must rely on notifications for this to work...
    // do you need a custom notification, then?
    // probably... that probably will work better, ultimately.
    // and you wouldn't make this an operation because it's only executed once in the code and you can control that very easily
    func fetch_json_list(_ url: String, completion: @escaping () -> () ){
        print("in json fetch...")
        guard let url_obj = URL(string: url) else {print("url issue");return}
        session.dataTask(with: url_obj) { (data, response, error) in
            if let _ = error{print("ERROR: ", error);return}
            guard let data = data else{print("NO DATA!");return}
            do {
                let unknown_type = try self.decoder.decode(SingleSong.self, from: data)
                
                
                
            } catch let json_error {print("error unserializing json in fetch_json_list: ", json_error)}
            
        }.resume()
    }
    /*
     func fetch_list_of_pokemon(_ url: String, offset page_offset_copy: Int, completion: @escaping () -> () ){
         guard let url_obj = URL(string:url) else{return}
         session.dataTask(with: url_obj) { (data, response, error) in
         if let _ = error{return}
         guard let data = data else{return}
         do {
             let json_response = try JSONDecoder().decode(Pokemon_Previous_Next_And_Results.self, from: data)
             
             var count = 0
             for index in page_offset_copy..<(page_offset_copy + page_size) {
                 if index < max_pokemon {
                     pokemon_previous_next_and_results.results[index] = json_response.results[count]
                     count += 1
                 }
             }
             pokemon_previous_next_and_results.previous = json_response.previous
             pokemon_previous_next_and_results.next = json_response.next
             completion()
         } catch let json_error {print("error unserializing json in fetch_list_of_pokemon: ", json_error)}
         return
     }.resume()
 }*/
    
    
}
