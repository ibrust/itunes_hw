//
//  CustomCell.swift
//  itunes_hw
//
//  Created by Field Employee on 11/6/20.
//

import UIKit

class CustomCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var refreshed = 0
    
    @IBOutlet weak var image_outlet: UIImageView!
    @IBOutlet weak var album_title_outlet: UILabel!
    @IBOutlet weak var artist_name_outlet: UILabel!
    
    @IBAction func star_button(_ sender: UIButton) {
        
    }
    
}
