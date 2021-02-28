//
//  CastCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit

class CastCell: UICollectionViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageProfile.layer.cornerRadius = 8
        imageProfile.layer.cornerCurve  = .continuous
    }

}
