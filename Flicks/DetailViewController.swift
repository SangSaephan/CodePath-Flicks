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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Movie Details"
        
        // Set size for scroll view
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let baseUrl = "https://image.tmdb.org/t/p/w342"
        
        titleLabel.text = title
        overviewLabel.text = overview
        overviewLabel.sizeToFit()
        
        if let posterUrl = movie["poster_path"] as? String {
            let imageUrl = NSURL(string: baseUrl + posterUrl)
            posterImageView.setImageWith(imageUrl! as URL)
        }
    }

}
