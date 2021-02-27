//
//  DetailsViewControllerCollectionViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import UIKit

class DetailsViewController: UICollectionViewController {

    let movieId: Int
    
    
    private(set) lazy var output: DetailsInteractorInput = {
       return DetailsInteractor(DetailsPresenter(self), DetailsWorker())
    }()

    
    init(movieId: Int) {
        self.movieId = movieId
        
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("movieId required")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.delegate        = self
        collectionView.dataSource      = self
        
        output.fetchDetails(Details.Request(movieId: self.movieId))
    }

}

extension DetailsViewController: DetailsPresenterOutput {
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func showFailure(_ error: Error) {}
    
    func showSuccess(_ model: Details.ViewModel) {}
    
}
