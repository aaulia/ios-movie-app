//
//  FeedViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import UIKit
import Nuke

final class FeedViewController: UICollectionViewController {
    
    private let cellCorderRadius = CGFloat(8)
    private let movieCellPerLine = CGFloat(3)
    private let movieCellSpacing = CGFloat(10)
    private let movieCellRatio   = CGFloat(0.66666666666) // = 2 / 3
    
    private let contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
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
    
    
    private let feedType: FeedType
    private var viewModel = Feed.ViewModel(movies: [])
    
    
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
        collectionView.contentInset    = self.contentInset
        collectionView.delegate        = self
        collectionView.dataSource      = self

        collectionView.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        
        let nibMovieCell = UINib(nibName: "MovieViewCell", bundle: nil)
        collectionView.register(nibMovieCell, forCellWithReuseIdentifier: "MovieCell")
        
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath)
        let data = viewModel.movies[indexPath.row]
        
        if let movieCell = cell as? MovieViewCell {
            movieCell.layer.cornerRadius = cellCorderRadius
            movieCell.layer.cornerCurve  = .continuous
            
            if let poster = data.poster {
                Nuke.loadImage(with: poster, options: nukeOptions, into: movieCell.imagePoster)
            } else {
                movieCell.imagePoster.contentMode = nukeOptions.contentModes?.failure ?? .center
                movieCell.imagePoster.image       = nukeOptions.failureImage
            }
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
        collectionView.reloadData()
    }
    
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = movieCellSpacing * (movieCellPerLine + 1)
        let content: CGFloat = collectionView.bounds.width - spacing
        
        let w = content / movieCellPerLine
        let h = w / movieCellRatio
        
        return CGSize(width: w, height: h)
    }
    
}
