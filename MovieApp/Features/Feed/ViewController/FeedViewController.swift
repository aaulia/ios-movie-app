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
    
    private let refreshControl = UIRefreshControl()
    private let brokenImage = UIImage(named: "icon_broken_image")?.withTintColor(UIColor.systemGray4)
    
    
    private let feedType: FeedType
    private var viewModel = Feed.ViewModel(movies: [])
    
    
    private(set) lazy var output: FeedInteractorInput = {
       return FeedInteractor(FeedPresenter(self), FeedWorker())
    }()
    private let router: FeedRouting = FeedRouter()

    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.title = feedType.name
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.movies[indexPath.row]
        router.routeToDetails(movieId: movie.id)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 10 * 4
        let content: CGFloat = movieCollection.bounds.width - spacing
        
        let w = content / 3
        let h = (w / 2) * 3
        
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
            
            if let poster = data.image {
                movieCell.imagePoster.contentMode = .scaleAspectFill
                Nuke.loadImage(with: poster, into: movieCell.imagePoster)
            } else {
                movieCell.imagePoster.contentMode = .center
                movieCell.imagePoster.image = brokenImage
            }
        }
        
        return cell
    }
    
}
