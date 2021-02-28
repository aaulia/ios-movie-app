//
//  DetailsCastsCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit
import Nuke

class DetailsCastsCell: UICollectionViewCell, DetailsSection {

    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet private var maxHeightConstraint: NSLayoutConstraint! {
        didSet {
            maxHeightConstraint.isActive = false
        }
    }

    @IBOutlet private var maxWidthConstraint: NSLayoutConstraint! {
        didSet {
            maxWidthConstraint.isActive = false
        }
    }
    
    
    var maxHeight: CGFloat? = 0 {
        didSet {
            guard let maxHeight = maxHeight else {
                return
            }
            
            maxHeightConstraint.isActive = true
            maxHeightConstraint.constant = maxHeight
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
    
    
    var casts: [Details.ViewModel.Cast] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate        = self
        collectionView.dataSource      = self
        collectionView.isScrollEnabled = false
        
        let nib = UINib(nibName: "CastCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CastCell")
    }

    func setup(collectionView: UICollectionView, model: DetailsSectionModel) {
        self.maxWidth = collectionView.bounds.width
        
        casts = model.casts ?? []
        
        let rowSize: CGFloat = CGFloat(ceilf(Float(casts.count) / 4))
        let spacing: CGFloat = 10 * 5
        let content: CGFloat = collectionView.bounds.width - spacing
        
        let w = content / 4
        let h = w * 3 / 2
        
        maxHeight = (h * rowSize) + (10 * (rowSize + 1))
    }
}

extension DetailsCastsCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10 * 5
        let content: CGFloat = collectionView.bounds.width - spacing
        
        let w = content / 4
        let h = w * 3 / 2
        
        return CGSize(width: w, height: h)
    }
    
}

extension DetailsCastsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath)
        let cast = casts[indexPath.row]
        
        if let castCell = cell as? CastCell {
            if let profile = cast.profile {
                Nuke.loadImage(with: profile, into: castCell.imageProfile)
            } else {
                castCell.imageProfile.image = nil
            }
        }
        
        return cell
    }
    
}
