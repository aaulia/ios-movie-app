//
//  FeedRouter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation

protocol FeedRouting {
    func routeToDetails(movieId id: Int)
}

final class FeedRouter: FeedRouting {
    
    func routeToDetails(movieId id: Int) {
        // TODO: route to movie details
        debugPrint("Opening movie_id: \(id)")
    }
    
}
