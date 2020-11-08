//
//  TableController.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit
import CoreData

let reuse_id = "custom_cell"

class TableController: UITableViewController {
    
    var binder = Binder()
    var current_image: UIImage? = nil
    private var observer: NSObjectProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.binder.bind_cellupdatehandler { [weak self] row in
            DispatchQueue.main.async {
                guard let self = self else{return}
                                
                let index_path = IndexPath(row: row, section: 0)
                
                let song_data = self.binder.return_song()
                
                let cell = self.tableView.cellForRow(at: index_path) as? CustomCell
                
                //print("SONG DATA IS: ", row, song_data)
                cell?.artist_name_outlet.text = self.binder.songs_array[row]?.artistName
                cell?.album_title_outlet.text = self.binder.songs_array[row]?.unique_id
                                
                /* let index_path_array = [index_path]
                // creates a cycle...
                // how to solve this?
                self.tableView.reloadRows(at: index_path_array, with: .none)*/
                
            }
        }
        
        
        
        observer = NotificationCenter.default.addObserver(
            forName: .List_Fetch_Complete,
            object: nil,
            queue: OperationQueue.main) { _ in
            
            let index_paths = self.tableView.indexPathsForVisibleRows
            
            for index_path in index_paths!{
                self.tableView.reloadRows(at: [index_path], with: .none)
            }
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil,
            queue: nil) { (notification) in
            
            guard let user_info = notification.userInfo else {return}
            
            DispatchQueue.main.async{
                let visible_cells_index_paths = self.tableView.indexPathsForVisibleRows
                
                if let inserts = user_info[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                    for inserted_entity in inserts {
                        if let single_song = inserted_entity as? SingleSong {
                            for path in visible_cells_index_paths!{
                                if path.row == Int(single_song.unique_id!){
                                    print("MATCHED SONG: ", single_song)
                                    let cell = self.tableView.cellForRow(at: path) as? CustomCell
                                    cell?.artist_name_outlet.text = single_song.artistName
                                    cell?.album_title_outlet.text = single_song.unique_id
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

extension TableController {
    @objc func get_image(_ row: Int){
        self.binder.get_image(row)
    }
    @objc func get_song_data(_ row: Int){
        self.binder.get_song_data(row)
    }
}


extension TableController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_id, for: indexPath) as? CustomCell
        print("IN CELL FOR ROW AT")
        
        self.get_song_data(indexPath.row)
        
        return cell ?? CustomCell()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return total_rows
    }
}

