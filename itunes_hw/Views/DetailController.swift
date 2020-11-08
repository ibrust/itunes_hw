//
//  DetailController.swift
//  itunes_hw
//
//  Created by Field Employee on 11/8/20.
//

import UIKit

class DetailController: UIViewController {

    var temp_image: UIImage? = nil
    var temp_artist_name: String? = nil
    
    @IBOutlet weak var title_label_outlet: UILabel!
    
    @IBOutlet weak var image_view_outlet: UIImageView!
    
    
    @IBAction func star_button_pressed(_ sender: UIButton) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title_label_outlet.text = self.temp_artist_name ?? ""
        self.image_view_outlet.image = self.temp_image ?? UIImage()
    }

}
