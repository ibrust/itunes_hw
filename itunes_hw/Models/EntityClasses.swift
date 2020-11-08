//
//  song.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

class SingleSong: NSManagedObject, Codable {
    
    // it would probably be better to create this in the json and then
    // decode it here... so actually add to the json
    // that way you ensure it's all in order, it's not clear that
    // the constructed objects will always be in order... also this is
    // a strange mechanism when you divide it by 2 down below
    static var static_unique_id = 0

    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext!] as? NSManagedObjectContext
        else{
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        // got a 'bad access' error here, looked like a multithreaded issue...
        // maybe try creating the json on the main thread or something...
        // if you can do that, maybe use the app delegate context? 
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.artistName = try container.decode(String.self, forKey: .artistName)
        self.artistId = try container.decode(String.self, forKey: .artistId)
        self.id = try container.decode(String.self, forKey: .id)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.name = try container.decode(String.self, forKey: .name)
        self.kind = try container.decode(String.self, forKey: .kind)
        self.copyright = try container.decode(String.self, forKey: .copyright)
        self.artistUrl = try container.decode(String.self, forKey: .artistUrl)
        self.artworkUrl100 = try container.decode(String.self, forKey: .artworkUrl100)
        
        // you might actually check whether the genre is in the database before decoding it... right?
        self.genres = try container.decode(Set<SongGenre>.self, forKey: .genres) as NSSet
        
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(artistName, forKey: .artistName)
        try container.encode(artistId, forKey: .artistId)
        try container.encode(id, forKey: .id)
        try container.encode(releaseDate, forKey: .releaseDate)
        try container.encode(name, forKey: .name)
        try container.encode(kind, forKey: .kind)
        try container.encode(copyright, forKey: .copyright)
        try container.encode(artistUrl, forKey: .artistUrl)
        try container.encode(artworkUrl100, forKey: .artworkUrl100)
        try container.encode(genres as! Set<SongGenre>, forKey: .genres)
    }
    
    enum CodingKeys: CodingKey {
        case artistName, artistId, id, releaseDate, name, kind, copyright, artistUrl, artworkUrl100, genres
    }
    
    override func awakeFromInsert(){
        super.awakeFromInsert()
        // it awakes from insert twice since i save it in a child and parent context, apparently...
        if Int(SingleSong.static_unique_id) % 2 == 0 {
            unique_id = String(SingleSong.static_unique_id / 2)
        }
        SingleSong.static_unique_id += 1
    }
    
}


class SongGenre: NSManagedObject, Codable {
    
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext!] as? NSManagedObjectContext
        else{
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(context: context)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.genreId = try container.decode(String.self, forKey: .genreId)
        self.name = try container.decode(String.self, forKey: .name)
        self.url = try container.decode(String.self, forKey: .url)
        
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(genreId, forKey: .genreId)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)

    }
    
    enum CodingKeys: CodingKey {
        case genreId, name, url
    }
}


struct JSON_struct: Codable {
    var feed: Feed
    
    struct Feed: Codable {
        var results: [SingleSong]
    }
}
