//
//  DetailsPrimaryCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit
import Nuke

class DetailsPrimaryCell: UICollectionViewCell, DetailsSection {

    @IBOutlet weak var imageBackdrop: UIImageView!
    @IBOutlet weak var imagePoster  : UIImageView!
    @IBOutlet weak var labelTitle   : UILabel!
    @IBOutlet weak var labelRating  : UILabel!
    
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
        
        var vfxStyle: UIBlurEffect.Style
        
        switch traitCollection.userInterfaceStyle {
        case .dark: vfxStyle = .dark
        default   : vfxStyle = .light
        }
        
        let vfxView = UIVisualEffectView(effect: UIBlurEffect(style: vfxStyle))
        vfxView.frame = imageBackdrop.bounds
        vfxView.alpha = 0.75
        imageBackdrop.addSubview(vfxView)

        imagePoster.layer.cornerRadius  = 8
        imagePoster.layer.cornerCurve   = .continuous
        
        labelRating.layer.masksToBounds = true
        labelRating.backgroundColor     = UIColor.black.withAlphaComponent(0.5)
        labelRating.layer.cornerRadius  = 8
        labelRating.layer.cornerCurve   = .continuous
    }

    func setup(collectionView: UICollectionView, model: DetailsSectionModel) {
        self.maxWidth        = collectionView.bounds.width
        self.labelTitle.text = model.movie.title
        
        if let rating = model.movie.rating {
            self.labelRating.isHidden = false
            self.labelRating.text     = String(format: "★ %.1f", rating)
        } else {
            self.labelRating.isHidden = true
        }
        
        if let poster = model.movie.poster {
            Nuke.loadImage(with: poster, into: self.imagePoster)
        } else {
            self.imagePoster.image = nil
        }
        
        if let backdrop = model.movie.backdrop {
            Nuke.loadImage(with: backdrop, into: self.imageBackdrop)
        } else {
            self.imageBackdrop.image = nil
        }

    }
}
