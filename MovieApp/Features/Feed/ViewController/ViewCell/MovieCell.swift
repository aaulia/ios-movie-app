//
//  FeedViewCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import UIKit
import Nuke

class MovieCell: UICollectionViewCell {
    
    static let nibName    = "MovieCell"
    static let identifier = "MovieCell"

    private enum Config {
        
        static let cornerRadius = CGFloat(8)
        
        private static let failureImage = UIImage(named: "icon_broken_image")? .withTintColor(UIColor.systemGray4)
        private static let placeholder  = UIImage(named: "icon_loading_image")?.withTintColor(UIColor.systemGray4)

        static var nukeOptions  = {
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
    
    
    @IBOutlet weak var imagePoster: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = Config.cornerRadius
        self.layer.cornerCurve  = .continuous
    }

    func render(movie: Feed.ViewModel.Movie) {
        if let poster = movie.poster {
            Nuke.loadImage(with: poster, options: Config.nukeOptions, into: imagePoster)
        } else {
            imagePoster.contentMode = Config.nukeOptions.contentModes?.failure ?? .center
            imagePoster.image       = Config.nukeOptions.failureImage
        }
    }
}
