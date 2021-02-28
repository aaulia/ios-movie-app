//
//  DetailsViewControllerCollectionViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import UIKit

class DetailsViewController: UICollectionViewController {

    struct Data {
        let id      : Int
        let title   : String
        let overview: String
        let rating  : Float?
        let poster  : URL?
        let backdrop: URL?
    }
    
    let data: Data
    
    
    private(set) lazy var output: DetailsInteractorInput = {
       return DetailsInteractor(DetailsPresenter(self), DetailsWorker())
    }()

    
    init(data: Data) {
        self.data = data
        
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
        
        output.fetchCredits(movieId: data.id)
    }

}

extension DetailsViewController: DetailsPresenterOutput {
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func showFailure(_ error: Error) {}
    
    func showSuccess(_ model: Details.ViewModel) {
        for cast in model.casts {
            print("\(cast.name) -> \(cast.character)")
        }
    }
    
}
