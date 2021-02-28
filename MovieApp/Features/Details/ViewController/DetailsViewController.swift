//
//  DetailsViewControllerCollectionViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import UIKit
import Nuke

class DetailsViewController: UICollectionViewController {

    struct Data {
        let id      : Int
        let title   : String
        let overview: String
        let rating  : Float?
        let poster  : URL?
        let backdrop: URL?
    }
    
    let movie: Data
    
    
    private(set) lazy var output: DetailsInteractorInput = {
       return DetailsInteractor(DetailsPresenter(self), DetailsWorker())
    }()

    
    init(data: Data) {
        self.movie = data
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("movieId required")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.delegate        = self
        collectionView.dataSource      = self

        let nibDetailsPrimary = UINib(nibName: "DetailsPrimaryCell", bundle: nil)
        collectionView.register(nibDetailsPrimary, forCellWithReuseIdentifier: "DetailsPrimary")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailsPrimary", for: indexPath)
        
        if let detailsPrimary = cell as? DetailsPrimaryCell {
            detailsPrimary.maxWidth = collectionView.bounds.width
            
            detailsPrimary.labelTitle.text  = movie.title
            
            if let rating = movie.rating {
                detailsPrimary.labelRating.isHidden = false
                detailsPrimary.labelRating.text     = String(format: "★ %.1f", rating)
            } else {
                detailsPrimary.labelRating.isHidden = true
            }
            
            if let poster = movie.poster {
                Nuke.loadImage(with: poster, into: detailsPrimary.imagePoster)
            } else {
                detailsPrimary.imagePoster.image = nil
            }
            
            if let backdrop = movie.backdrop {
                Nuke.loadImage(with: backdrop, into: detailsPrimary.imageBackdrop)
            } else {
                detailsPrimary.imageBackdrop.image = nil
            }
        }
        
        return cell
    }

}

extension DetailsViewController: DetailsPresenterOutput {
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func showFailure(_ error: Error) {}
    
    func showSuccess(_ model: Details.ViewModel) {}
    
}
