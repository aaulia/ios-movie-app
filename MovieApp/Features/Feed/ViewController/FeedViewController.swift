//
//  FeedViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import UIKit
import Nuke

final class FeedViewController: UIViewController {
    
    @IBOutlet weak var movieCollection: UICollectionView!
    
    private let feedType: FeedType

    private let refreshControl = UIRefreshControl()
    
    private var viewModel = Feed.ViewModel(movies: [])
    
    private(set) lazy var output: FeedInteractorInput = {
       return FeedInteractor(FeedPresenter(self), FeedWorker())
    }()

    
    init(withType type: FeedType) {
        self.feedType = type

        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.feedType = .nowPlaying
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        movieCollection.refreshControl = refreshControl
        movieCollection.delegate       = self
        movieCollection.dataSource     = self
        movieCollection.register(UINib(nibName: "MovieViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        
        output.fetchMovies(Feed.Request(feedType: self.feedType))
    }
    
    
    @objc private func onRefresh(_ sender: AnyObject) {
        output.fetchMovies(Feed.Request(feedType: self.feedType))
    }
    
    private func setup() {
        tabBarItem.title = feedType.name
        tabBarItem.image = UIImage(named: feedType.icon)
    }
    
}

extension FeedViewController: FeedPresenterOutput {
    
    func showLoading() {
        refreshControl.beginRefreshing()
    }
    
    func hideLoading() {
        refreshControl.endRefreshing()
    }
    
    func showFailure(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccess(_ model: Feed.ViewModel) {
        viewModel = model
        movieCollection.reloadData()
    }
    
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacingSum: CGFloat = 10 * 3
        let contentSum: CGFloat = movieCollection.bounds.width - spacingSum
        
        let w = contentSum / 2.0
        let h = w / 2 * 3
        
        return CGSize(width: w, height: h)
    }
    
}

extension FeedViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = movieCollection.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath)
        let data = viewModel.movies[indexPath.row]
        
        if let movieCell = cell as? MovieViewCell {
            movieCell.layer.cornerRadius = 8.0
            movieCell.layer.cornerCurve = .continuous
            movieCell.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            if let poster = data.image {
                Nuke.loadImage(with: poster, into: movieCell.imagePoster)
            } else {
                movieCell.imagePoster.image = nil
            }
        }
        
        return cell
    }
    
}
