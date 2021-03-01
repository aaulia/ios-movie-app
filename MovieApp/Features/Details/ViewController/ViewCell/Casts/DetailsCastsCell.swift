//
//  DetailsCastsCell.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import UIKit
import Nuke

class DetailsCastsCell: UICollectionViewCell, DetailsCell {
    
    private enum Config {

        static let castCellPerLine = CGFloat(4)
        static let castCellSpacing = CGFloat(10)
        static let castCellRatio   = CGFloat(0.66666666666) // = 2 / 3
        
    }


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

    
    var itemSize: CGSize = CGSize.zero
    var casts   : [Details.ViewModel.Cast] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.isScrollEnabled = false
        collectionView.delegate        = self
        collectionView.dataSource      = self
        
        let nib = UINib(nibName: CastCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CastCell.identifier)
    }

    func render(parentView: UIView, model: Details.ViewModel) {
        calculateDimensions(parentView, withItemCount: model.casts.count)
        self.casts = model.casts
    }
    
    private func calculateDimensions(_ parentView: UIView, withItemCount: Int) {
        let contentWidth = parentView.bounds.width - (Config.castCellSpacing * (Config.castCellPerLine + 1))
        let itemWidth    = contentWidth / Config.castCellPerLine
        let itemHeight   = itemWidth / Config.castCellRatio
        let rowCount     = ceil(CGFloat(withItemCount) / Config.castCellPerLine)

        self.maxWidth  = parentView.bounds.width
        self.maxHeight = (itemHeight * rowCount) + (Config.castCellSpacing * (rowCount + 1))
        self.itemSize  = CGSize(width: itemWidth, height: itemHeight)
    }
    
}

extension DetailsCastsCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
}

extension DetailsCastsCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath)
        let cast = casts[indexPath.row]
        
        if let castCell = cell as? CastCell {
            castCell.render(cast)
        }
        
        return cell
    }
    
}
