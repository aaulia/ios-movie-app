//
//  ViewController.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 24/02/21.
//

import UIKit

final class HomeViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            FeedViewController(withType: .nowPlaying),
            FeedViewController(withType: .popular),
            FeedViewController(withType: .topRated),
            FeedViewController(withType: .upcoming)
        ]
    }

}
