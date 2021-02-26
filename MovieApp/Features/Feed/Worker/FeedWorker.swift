//
//  FeedWorker.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation
import Alamofire
import Combine

protocol FeedWorkerProtocol {
    func fetchMovies(_ feedType: FeedType) -> AnyPublisher<Feed.Response, AFError>
}

final class FeedWorker: FeedWorkerProtocol {
    
    func fetchMovies(_ feedType: FeedType) -> AnyPublisher<Feed.Response, AFError> {
        var route: Route
        
        switch feedType {
        case .nowPlaying: route = ApiRoute.TMDB.nowPlaying
        case .popular   : route = ApiRoute.TMDB.popular
        case .topRated  : route = ApiRoute.TMDB.topRated
        case .upcoming  : route = ApiRoute.TMDB.upcoming
        }
        
        return ApiRouter.request(route, ofType: Feed.Response.self)
    }
    
    
}
