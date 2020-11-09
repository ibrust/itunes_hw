//
//  TableController.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData

let reuse_id = "custom_cell"

class TableController: UITableViewController, UITableViewDataSourcePrefetching {
    
    var binder = Binder()
    var current_image: UIImage? = nil
    private var list_fetch_observer: NSObjectProtocol?
    private var database_observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.prefetchDataSource = self
        
        self.binder.bind_cellupdatehandler { [weak self] row in
            DispatchQueue.main.async {
                guard let self = self else{return}
                                
                let index_path = IndexPath(row: row, section: 0)
                let cell = self.tableView.cellForRow(at: index_path) as? CustomCell
                if let artist_name = self.binder.songs_array[row]?.artistName {
                    cell?.artist_name_outlet.text = artist_name
                }
                if let unique_id = self.binder.songs_array[row]?.unique_id {
                    cell?.album_title_outlet.text = unique_id
                }
                if let image_data = self.binder.songs_array[row]?.image_data {
                    cell?.image_outlet.image = UIImage(data: image_data)
                }
                if let toggle_state = self.binder.songs_array[row]?.star_toggle{
                    if toggle_state == false {
                        cell?.star_button_outlet.setImage(UIImage(systemName: "star"), for: .normal)
                    } else {
                        cell?.star_button_outlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                }
            }
        }
        
        list_fetch_observer = NotificationCenter.default.addObserver(
            forName: .List_Fetch_Complete,
            object: nil,
            queue: OperationQueue.main) { _ in
            
            let index_paths = self.tableView.indexPathsForVisibleRows
            
            for index_path in index_paths!{
                self.tableView.reloadRows(at: [index_path], with: .none)
            }
        }
        
        database_observer = NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil,
            queue: nil) { (notification) in
            
            guard let user_info = notification.userInfo else {return}
            
            DispatchQueue.main.async{
                let visible_cells_index_paths = self.tableView.indexPathsForVisibleRows
                
                if let updates = user_info[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
                    for updated_entity in updates {
                        if let single_song = updated_entity as? SingleSong {
                            for path in visible_cells_index_paths!{
                                if path.row == Int(single_song.unique_id!){
                                    let cell = self.tableView.cellForRow(at: path) as? CustomCell
                                    if let artist_name = single_song.artistName{
                                        cell?.artist_name_outlet.text = artist_name
                                    }
                                    if let unique_id = single_song.unique_id{
                                        cell?.album_title_outlet.text = unique_id
                                    }
                                }
                            }
                            if let image_data = single_song.image_data{
                                let row = Int(single_song.unique_id!)
                                let path = IndexPath(row: row!, section: 0)
                                let cell = self.tableView.cellForRow(at: path) as? CustomCell
                                cell?.image_outlet.image = UIImage(data: image_data)
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let list_fetch_observer = self.list_fetch_observer {
            NotificationCenter.default.removeObserver(list_fetch_observer)
        }
        if let database_observer = self.database_observer {
            NotificationCenter.default.removeObserver(database_observer)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "detail_segue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let sent_row = sender as? Int ?? 0
        guard let detail_controller = segue.destination as? DetailController else{return}
        let song_data = self.binder.return_song_data(sent_row)
        
        if let image_data = song_data?.image_data {
            detail_controller.temp_image = UIImage(data: image_data)
        }
        if let artist_name = song_data?.artistName {
            detail_controller.temp_artist_name = artist_name
        }
        if let id = song_data?.unique_id, let album_title = song_data?.name {
            detail_controller.temp_album_title = id + " - " + album_title
        }
        
        if let release_date = song_data?.releaseDate {
            let date_formatter = DateFormatter()
            date_formatter.dateFormat = "yyyy-MM-dd"
            let date_reformatter = DateFormatter()
            date_reformatter.dateFormat = "MMM dd, yyyy"
            if let date = date_formatter.date(from: release_date){
                detail_controller.temp_release_date = date_reformatter.string(from: date)
            } else{
                detail_controller.temp_release_date = release_date
            }
        }
        if let genres = song_data?.genres {
            var genre_string = "GENRES:\n"
            for genre in genres {
                let converted_genre = genre as? SongGenre
                if converted_genre?.name != "Music"{
                    genre_string += ((converted_genre?.name) ?? "" ) + "\n"
                }
            }
            detail_controller.temp_genres = genre_string
        }
        if let toggle_state = song_data?.star_toggle {
            if toggle_state == true {
                detail_controller.button_state = true
            } else if toggle_state == false {
                detail_controller.button_state = false
            }
        }
        
        detail_controller.binder = self.binder
        detail_controller.detail_id = sent_row
    }
}


extension TableController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_id, for: indexPath) as? CustomCell
        
        cell?.cell_id = indexPath.row
        if cell?.table_controller_reference == nil {
            cell?.table_controller_reference = self
        }
        
        self.get_song_data(indexPath.row)
                
        return cell ?? CustomCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total_rows
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        var highest_row = 0
        guard var highest_path: IndexPath = indexPaths.first else{return}
        for path in indexPaths {
            if path.row > highest_row{
                highest_row = path.row
                highest_path = path
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_id, for: highest_path) as? CustomCell
        
        cell?.cell_id = highest_row
        if cell?.table_controller_reference == nil {
            cell?.table_controller_reference = self
        }
        
        self.get_song_data(highest_row)
                
        return
    }
}

extension TableController {
    @objc func get_song_data(_ row: Int){
        self.binder.get_song_data(row)
    }
    @objc func toggle_star(_ row: Int){
        self.binder.toggle_star_button(row)
    }
}
