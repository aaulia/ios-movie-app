//
//  DetailsPrimaryCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit

class DetailsPrimaryCell: UICollectionViewCell {

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

}
