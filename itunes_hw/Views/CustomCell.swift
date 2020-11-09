//
//  CustomCell.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit

class CustomCell: UITableViewCell {
    
    var table_controller_reference: TableController? = nil
    var cell_id: Int? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBOutlet weak var image_outlet: UIImageView!
    @IBOutlet weak var album_title_outlet: UILabel!
    @IBOutlet weak var artist_name_outlet: UILabel!
    
    @IBOutlet weak var star_button_outlet: UIButton!
    
    @IBAction func star_button(_ sender: UIButton) {
        guard let cell_id = self.cell_id else{return}
        table_controller_reference?.toggle_star(cell_id)
    }
    
}
