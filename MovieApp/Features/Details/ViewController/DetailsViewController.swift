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
    
    enum CellType: CaseIterable {
        case primary
        case overview
        case casts
        
        var identifier: String {
            switch self {
            case .primary : return "DetailsPrimary"
            case .overview: return "DetailsOverview"
            case .casts   : return "DetailsCasts"
            }
        }
        
        var nibName: String {
            switch self {
            case .primary : return "DetailsPrimaryCell"
            case .overview: return "DetailsOverviewCell"
            case .casts   : return "DetailsCastsCell"
            }
        }
        
    }
    
    
    var cells: [CellType] = [.primary, .overview, .casts]
    var model: Details.ViewModel {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    private(set) lazy var output: DetailsInteractorInput = {
       return DetailsInteractor(DetailsPresenter(self), DetailsWorker())
    }()

    
    init(data: Data) {
        self.model = Details.ViewModel(
            id      : data.id,
            title   : data.title,
            overview: data.overview,
            rating  : data.rating,
            poster  : data.poster,
            backdrop: data.backdrop,
            casts   : []
        )
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("movieId required")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.backgroundColor              = UIColor.systemBackground
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate                     = self
        collectionView.dataSource                   = self

        CellType.allCases.forEach { type in
            let nib = UINib(nibName: type.nibName, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: type.identifier)
        }
        
        output.fetchCredits(movieId: model.id)
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.bounces = collectionView.contentOffset.y > 100
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath)
        
        if let section = cell as? DetailsCell {
            section.render(parentView: collectionView, model: self.model)
        }
                
        return cell
    }

}

extension DetailsViewController: DetailsPresenterOutput {
    
    func showSuccess(_ casts: [Details.ViewModel.Cast]) {
        if casts.isEmpty {
            return
        }
        
        self.model = self.model.copy(casts: casts)
    }
    
}
