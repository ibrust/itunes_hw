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
    }
    
    
    
    @IBOutlet weak var image_outlet: UIImageView!
    @IBOutlet weak var album_title_outlet: UILabel!
    @IBOutlet weak var artist_name_outlet: UILabel!
    
    @IBOutlet weak var star_button_outlet: UIButton!
    
    @IBAction func star_button(_ sender: UIButton) {
        
    }
    
}
