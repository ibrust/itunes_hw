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
    var temp_genres: String? = nil
    var temp_album_title: String? = nil
    var temp_release_date: String? = nil
    var temp_button_state: Bool? = nil
    
    @IBOutlet weak var genres_outlet: UILabel!
    @IBOutlet weak var title_label_outlet: UILabel!
    @IBOutlet weak var image_view_outlet: UIImageView!
    @IBOutlet weak var artist_name_outlet: UILabel!
    @IBOutlet weak var release_date_outlet: UILabel!
    
    @IBOutlet weak var star_button_outlet: UIButton!
    @IBAction func star_button_pressed(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artist_name_outlet.text = self.temp_artist_name ?? ""
        self.image_view_outlet.image = self.temp_image ?? UIImage()
        self.genres_outlet.text = self.temp_genres ?? ""
        self.title_label_outlet.text = temp_album_title ?? ""
        self.release_date_outlet.text = temp_release_date ?? ""
    }

}
