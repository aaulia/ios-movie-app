//
//  DetailsWorker.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Alamofire
import Combine
import Foundation

protocol DetailsWorkerProtocol {
    func fetchDetails(movieId: Int) -> AnyPublisher<Details.Response, AFError>
}

final class DetailsWorker: DetailsWorkerProtocol {
    
    func fetchDetails(movieId: Int) -> AnyPublisher<Details.Response, AFError> {
        return ApiRouter.request(ApiRoute.TMDB.details(movieId), ofType: Details.Response.self)
    }
    
}
