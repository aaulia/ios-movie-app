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
    
    enum SectionType: CaseIterable {
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
    
    
    let movie: Data
    var cells: [SectionType] = [.primary, .overview, .casts]
    var model: DetailsSectionModel
    
    
    private(set) lazy var output: DetailsInteractorInput = {
       return DetailsInteractor(DetailsPresenter(self), DetailsWorker())
    }()

    
    init(data: Data) {
        self.movie = data
        self.model = DetailsSectionModel(movie: data, casts: nil)
        
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

        SectionType.allCases.forEach { type in
            let nib = UINib(nibName: type.nibName, bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: type.identifier)
        }
        
        output.fetchCredits(movieId: movie.id)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = cells[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath)
        
        if let section = cell as? DetailsSection {
            section.setup(collectionView: collectionView, model: self.model)
        }
                
        return cell
    }

}

extension DetailsViewController: DetailsPresenterOutput {
    
    func showLoading() {}
    
    func hideLoading() {}
    
    func showFailure(_ error: Error) {}
    
    func showSuccess(_ model: Details.ViewModel) {
        if model.casts.isEmpty {
            return
        }
        
        self.model = DetailsSectionModel(movie: self.movie, casts: model.casts)
        
        if let row = cells.firstIndex(of: .casts) {
            collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
        }
    }
    
}
