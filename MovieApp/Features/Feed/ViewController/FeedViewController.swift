//
//  FeedViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import UIKit
import Nuke

final class FeedViewController: UICollectionViewController {
    
    private enum Config {

        static let movieCellPerLine = CGFloat(3)
        static let movieCellSpacing = CGFloat(10)
        static let movieCellRatio   = CGFloat(0.66666666666) // = 2 / 3
        
        static let contentInset = UIEdgeInsets(
            top   : movieCellSpacing,
            left  : movieCellSpacing,
            bottom: movieCellSpacing,
            right : movieCellSpacing
        )

    }
    
    
    private let feedType: FeedType
    private var viewModel = Feed.ViewModel(movies: []) {
        didSet {
            collectionView.reloadData()
        }
    }

    private(set) lazy var itemSize: CGSize = {
        let spacing: CGFloat = Config.movieCellSpacing * (Config.movieCellPerLine + 1)
        let content: CGFloat = collectionView.bounds.width - spacing
        
        let w = content / Config.movieCellPerLine
        let h = w / Config.movieCellRatio
        
        return CGSize(width: w, height: h)
    }()
    
    
    private(set) lazy var router: FeedRouting = { FeedRouter(controller: self) }()
    private(set) lazy var output: FeedInteractorInput = {
       return FeedInteractor(FeedPresenter(self), FeedWorker())
    }()

    
    init(withType type: FeedType) {
        self.feedType = type

        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.feedType = .nowPlaying
        
        super.init(coder: aDecoder)
        setup()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.refreshControl  = UIRefreshControl()
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.contentInset    = Config.contentInset
        collectionView.delegate        = self
        collectionView.dataSource      = self

        collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        let nibMovieCell = UINib(nibName: MovieCell.nibName, bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: MovieCell.identifier)
        
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = viewModel.movies[indexPath.row]
        router.routeToDetails(movie: data)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath)
        let data = viewModel.movies[indexPath.row]
        
        if let movieCell = cell as? MovieCell {
            movieCell.render(movie: data)
        }
        
        return cell
    }
    
}

extension FeedViewController: FeedPresenterOutput {
    
    func showLoading() {
        collectionView.refreshControl?.beginRefreshing()
    }
    
    func hideLoading() {
        collectionView.refreshControl?.endRefreshing()
    }
    
    func showFailure(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showSuccess(_ model: Feed.ViewModel) {
        viewModel = model
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
}
