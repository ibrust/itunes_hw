//
//  TableController.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit

let reuse_id = "custom_cell"

class TableController: UITableViewController {
    
    var binder = Binder()
    
    var current_image: UIImage? = nil
    

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
            DispatchQueue.main.async {
                guard let self = self else{return}
                
                let index_path = IndexPath(row: row, section: 0)
                let cell = self.tableView.cellForRow(at: index_path) as? CustomCell
                let song_data = self.binder.get_song_data(row)
                //cell?.album_title_outlet = song_data.albumTitle
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuse_id, for: indexPath)

        // Configure the cell...

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
}

