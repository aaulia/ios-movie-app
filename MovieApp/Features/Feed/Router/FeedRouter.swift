//
//  FeedRouter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation
import UIKit

protocol FeedRouting {
    func routeToDetails(movie: Feed.ViewModel.Movie)
}

final class FeedRouter: FeedRouting {
    
    weak var controller: UIViewController?
    
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func routeToDetails(movie: Feed.ViewModel.Movie) {
        let data = DetailsViewController.Data(
            id      : movie.id,
            title   : movie.title,
            overview: movie.overview,
            rating  : movie.rating,
            poster  : movie.poster,
            backdrop: movie.backdrop
        )
        
        controller?.present(DetailsViewController(data: data), animated: true)
    }
    
}
