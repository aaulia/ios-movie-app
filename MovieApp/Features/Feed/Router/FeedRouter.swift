//
//  FeedRouter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation
import UIKit

protocol FeedRouting {
    func routeToDetails(movieId id: Int)
}

final class FeedRouter: FeedRouting {
    
    weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func routeToDetails(movieId id: Int) {
        controller?.present(DetailsViewController(movieId: id), animated: true)
    }
    
}
