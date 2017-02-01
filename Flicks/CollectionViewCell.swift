//
//  CollectionViewCell.swift
//  Flicks
//
//  Created by Sang Saephan on 1/17/17.
//  Copyright © 2017 Sang Saephan. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    // Add rounded corners for each collection cell
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
}
