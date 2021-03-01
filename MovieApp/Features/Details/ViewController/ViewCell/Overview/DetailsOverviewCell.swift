//
//  DetailsOverviewCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit

class DetailsOverviewCell: UICollectionViewCell, DetailsCell {

    @IBOutlet weak var labelOverview: UILabel!
    
    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    
    var maxWidth: CGFloat? = 0 {
        didSet {
            guard let maxWidth = maxWidth else {
                return
            }
            
            maxWidthConstraint.isActive = true
            maxWidthConstraint.constant = maxWidth
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func render(parentView: UIView, model: Details.ViewModel) {
        self.maxWidth           = parentView.bounds.width
        self.labelOverview.text = model.overview
    }
    
}
