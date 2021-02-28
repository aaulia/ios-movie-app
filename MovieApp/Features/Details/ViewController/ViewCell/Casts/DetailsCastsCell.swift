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
    
    
    private let failureImage = UIImage(named: "icon_broken_image")?.withTintColor(UIColor.systemGray4)
    private let placeholder  = UIImage(named: "icon_loading_image")?.withTintColor(UIColor.systemGray4)

    private(set) lazy var nukeOptions  = {
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

    
    var casts   : [Details.ViewModel.Cast] = []
    var itemSize: CGSize = CGSize.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.isScrollEnabled = false
        collectionView.delegate        = self
        collectionView.dataSource      = self
        
        let nib = UINib(nibName: "CastCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CastCell")
    }

    func setup(collectionView: UICollectionView, model: DetailsSectionModel) {
        self.casts     = model.casts ?? []
        self.itemSize  = calculateItemSize(maxWidth: collectionView.bounds.width, itemPerLine: 4, spacing: 10, aspectRatio: 2 / 3)
        self.maxWidth  = collectionView.bounds.width
        self.maxHeight = calculateMaxHeight(size: self.itemSize, count: self.casts.count, itemPerLine: 4, spacing: 10)
        
        self.collectionView.reloadData()
    }
    
    private func calculateItemSize(maxWidth: CGFloat, itemPerLine count: Int, spacing: Int, aspectRatio: CGFloat) -> CGSize {
        let content: CGFloat = maxWidth - (CGFloat(spacing) * CGFloat(count + 1))
        let w = content / CGFloat(count)
        let h = w / aspectRatio
        
        return CGSize(width: w, height: h)
    }
    
    func calculateMaxHeight(size: CGSize, count: Int, itemPerLine: Int, spacing: Int) -> CGFloat {
        let rows = CGFloat(ceil(Float(count) / Float(itemPerLine)))
        return ((size.height + CGFloat(spacing)) * rows) + CGFloat(spacing)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastCell", for: indexPath)
        let cast = casts[indexPath.row]
        
        if let castCell = cell as? CastCell {
            castCell.labelName.text = cast.name
            
            if let profile = cast.profile {
                Nuke.loadImage(with: profile, options: nukeOptions, into: castCell.imageProfile)
            } else {
                castCell.imageProfile.contentMode = nukeOptions.contentModes?.failure ?? .center
                castCell.imageProfile.image       = nukeOptions.failureImage
            }
        }
        
        return cell
    }
    
}
