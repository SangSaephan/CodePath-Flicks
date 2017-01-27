//
//  DetailViewController.swift
//  Flicks
//
//  Created by Sang Saephan on 1/27/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        titleLabel.text = title
        overviewLabel.text = overview
        
        if let posterUrl = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterUrl)
            posterImageView.setImageWith(imageUrl! as URL)
        }
    }

}
