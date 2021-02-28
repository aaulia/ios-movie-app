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
    func fetchCredits(movieId id: Int) -> AnyPublisher<Details.Response, AFError>
}

final class DetailsWorker: DetailsWorkerProtocol {
    func fetchCredits(movieId id: Int) -> AnyPublisher<Details.Response, AFError> {
        return ApiRouter.request(ApiRoute.TMDB.credits(id), ofType: Details.Response.self)
    }
}
