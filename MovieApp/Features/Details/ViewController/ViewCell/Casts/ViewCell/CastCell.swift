//
//  CastCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit
import Nuke

class CastCell: UICollectionViewCell {
    
    static let nibName    = "CastCell"
    static let identifier = "CastCell"
    
    enum Config {
        static let cornerRadius = CGFloat(8)
        
        private static let failureImage = UIImage(named: "icon_broken_image")?.withTintColor(UIColor.systemGray4)
        private static let placeholder  = UIImage(named: "icon_loading_image")?.withTintColor(UIColor.systemGray4)

        static let nukeOptions  = {
            ImageLoadingOptions(
                placeholder : placeholder,
                failureImage: failureImage,
                contentModes: ImageLoadingOptions.ContentModes(
                    success    : .scaleAspectFill,
                    failure    : .center,
                    placeholder: .center
                )
            )
        }()

    }

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius  = Config.cornerRadius
        self.layer.cornerCurve   = .continuous
    }
    
    func render(_ cast: Details.ViewModel.Cast) {
        labelName.text = cast.name
        
        if let profile = cast.profile {
            Nuke.loadImage(with: profile, options: Config.nukeOptions, into: imageProfile)
        } else {
            imageProfile.contentMode = Config.nukeOptions.contentModes?.failure ?? .center
            imageProfile.image       = Config.nukeOptions.failureImage
        }
    }

}
