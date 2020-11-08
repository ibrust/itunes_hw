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
        
    
        // in this bind i'll have to update the cells UI elements
        // using the data fetched from the model.
        // remember this is bound to an observer of the model.
        // but when is the index passed in? where?
        // does it come from the model? how?
        // you could use the mutating cat method...
        // and just use the song rank or whatever
        // are these operations atomic? I have no idea...
        // set this, within the request manager, on the main thread... synchronously
        // could this specific operation be async though...?
        // and the method in the request manager be sync? not sure...
        // maybe try operations or some sort of synchronous queue in the request manager...? still not sure.
        // or you could even come up with a mechanism that doesn't require this... like notifications maybe? not sure, really...
        // some sort of array observation mechanism.......? duno. 
        self.binder.bind_cellupdatehandler { [weak self] row in
            print("in row: ", row, " cell update handler")
            DispatchQueue.main.async {
                guard let self = self else{return}
                                
                let index_path = IndexPath(row: row, section: 0)
                
                let song_data = self.binder.return_song()
                
                //let cell = self.tableView.cellForRow(at: index_path) as? CustomCell
                
                //print("SONG DATA IS: ", row, song_data)
                //cell?.artist_name_outlet.text = song_data?.artistName
                //cell?.album_title_outlet.text = song_data?.unique_id
                                
                /*let index_path_array = [index_path]
                // creates a cycle...
                // how to solve this?
                self.tableView.reloadRows(at: index_path_array, with: .none)*/
                
            }
        }
        
        
        
        observer = NotificationCenter.default.addObserver(
            forName: .List_Fetch_Complete,
            object: nil,
            queue: OperationQueue.main) { _ in
            
            print("OBSERVED SOMETHING")
        
            // maybe I should fetch the data in here...?
            // I still don't have access to the indices...
            // Why isn't the JSON in the database at this point, anyway? I thought it should be...?
        
            // it looks like the single mutating cat is getting all the data...
            // why?
            // you're going back through cellforrowat ...
            //
            let visible_cells = self.tableView.visibleCells
        
            let index_paths = self.tableView.indexPathsForVisibleRows
        
            print("VISIBLE CELLS: ", visible_cells)
        
            for index_path in index_paths!{
                self.tableView.reloadRows(at: [index_path], with: .none)
            }
        }
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: nil,
            queue: nil) { (notification) in
            
            guard let user_info = notification.userInfo else {return}
            
            /*
            print("in observer, calling bound_cellupdatehandler(1) with notification: ", notification)
            print("user info: ", user_info)*/
            //print("CONTEXT CHANGED...")
            DispatchQueue.main.async{
                //let visible_cells = self.tableView.visibleCells
                let visible_cells_index_paths = self.tableView.indexPathsForVisibleRows
                
                if let inserts = user_info[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                    //print("INSERTS: ", inserts)
                    
                    for inserted_entity in inserts {
                        //print("IN INSERT...")
                        if let single_song = inserted_entity as? SingleSong {
                            
                            for path in visible_cells_index_paths!{
                                if path.row == Int(single_song.unique_id!){
                                    print("MATCHED SONG: ", single_song)
                                    let cell = self.tableView.cellForRow(at: path) as? CustomCell
                                    cell?.artist_name_outlet.text = single_song.artistName
                                    cell?.artist_name_outlet.text = single_song.unique_id
                                }
                            }
                            
                        }
                        
                        //let cell = self.tableView.cellForRow(at: index_path) as? CustomCell
                        
                        //print("SONG DATA IS: ", row, song_data)
                        //cell?.artist_name_outlet.text = song_data?.artistName
                        //cell?.album_title_outlet.text = song_data?.unique_id
                    }
                    
                    
                    
                }
            }
        }
        
        // try to initially refresh every one of these cells...?
        // but how do you ever refresh cells then?
        // what triggers the refresh?
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if let observer = self.observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    // so what if you just refreshed the cells onscreen somehow..
    // instead of calling the fetch from cellforrowat, call it when they're first onscreen... somehow
    // you need to just do the UI updates in cellforrowat
    // in the handler... the bound handler... just do reload. there won't be a cycle
    // if you move the initial request out of cellforrowat
    // but how do you get the song data into the cell...????? the cellforrowat
    // and I don't think the mutating cat problem has been solved either....
    // why not just do that first? just to fix any potential source of error ...?
    // well the data is actually showing up in the handler...

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}

// functions for view stating its intent
// unlike in the example code, these aren't called by outlet actions but by cellforrowat and perhaps prefetch. these initiate the request loop.
// the handler is the mechanism which updates the data... right?
// yes, so you have the cell update handler which is actually called outside of cellforrowat, but it ultimately gets called as a consequence of the loop initiated in cellforrowat...
extension TableController {
    @objc func get_image(_ row: Int){
        self.binder.get_image(row)
    }
    @objc func get_song_data(_ row: Int){
        self.binder.get_song_data(row)
    }
}

// tableview management functions
extension TableController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_id, for: indexPath) as? CustomCell
        print("IN CELL FOR ROW AT")
        
        self.get_song_data(indexPath.row)
        
        return cell ?? CustomCell()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

