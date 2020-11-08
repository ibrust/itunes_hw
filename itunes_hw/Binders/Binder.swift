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
    var songs_array = [SingleSong?](repeating: nil, count: total_rows)
    var bound_cellupdatehandler: ((Int) -> ())? = nil
    
    var gotten_song: SingleSong? {
        willSet {
            if newValue != nil{
                guard let single_song = newValue as? SingleSong? else {return}
                guard let unique_id = single_song?.unique_id else {return}
                guard let converted_id = Int(unique_id) else {return}

                songs_array[converted_id] = single_song
                bound_cellupdatehandler?(converted_id)
            }
        }
    }
    
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
}

