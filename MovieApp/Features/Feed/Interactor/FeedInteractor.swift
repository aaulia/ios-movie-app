//
//  FeedInteractor.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation
import Combine

protocol FeedInteractorInput {
    func fetchMovies(_ request: Feed.Request)
}

protocol FeedInteractorOutput {
    func showLoading()
    func hideLoading()
    func showFailure(_ error: Error)
    func showSuccess(_ model: Feed.ViewModel)
}

final class FeedInteractor: FeedInteractorInput {
    
    let output: FeedInteractorOutput
    let worker: FeedWorkerProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ output: FeedInteractorOutput, _ worker: FeedWorkerProtocol) {
        self.output = output
        self.worker = worker
    }
    
    func fetchMovies(_ request: Feed.Request) {
        output.showLoading()
        worker.fetchMovies(request.feedType)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): self?.output.showFailure(error)
                    }
                },
                receiveValue: { [weak self] response in
                    let movies = response.results.map { entry -> Feed.ViewModel.Movie in
                        let poster = entry.poster.map { ApiRouter.getImageUrl(path: $0, forType: .poster) }
                        return Feed.ViewModel.Movie(id: entry.id, poster: poster)
                    }
                
                    self?.output.hideLoading()
                    self?.output.showSuccess(Feed.ViewModel(movies: movies))
                }
            )
            .store(in: &cancellables)
    }
    
}
