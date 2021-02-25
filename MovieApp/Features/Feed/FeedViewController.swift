//
//  FeedViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import UIKit

class FeedViewController: UIViewController {
    
    let feedType: FeedType
    
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
    
    private func setup() {
        tabBarItem.title = feedType.name
        tabBarItem.image = UIImage(named: feedType.icon)
    }
    
}

extension FeedViewController: FeedPresenterOutput {
    
}
