//
//  DetailsInteractor.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Combine
import Foundation

protocol DetailsInteractorInput {
    func fetchDetails(_ request: Details.Request)
}

protocol DetailsInteractorOutput {
    func showLoading()
    func hideLoading()
    func showFailure(_ error: Error)
    func showSuccess(_ model: Details.ViewModel)
}

final class DetailsInteractor: DetailsInteractorInput {
    
    let output: DetailsInteractorOutput
    let worker: DetailsWorkerProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ output: DetailsInteractorOutput, _ worker: DetailsWorkerProtocol) {
        self.output = output
        self.worker = worker
    }

    func fetchDetails(_ request: Details.Request) {
        worker.fetchDetails(movieId: request.movieId)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): self?.output.showFailure(error)
                    }
                },
                receiveValue: { [weak self] response in
                    let viewModel = Details.ViewModel(
                        title   : response.title,
                        overview: response.overview,
                        rating  : response.rating,
                        poster  : response.poster.map   { ApiRouter.getImageUrl(path: $0, forType: .poster) },
                        backdrop: response.backdrop.map { ApiRouter.getImageUrl(path: $0, forType: .backdrop) },
                        genres  : response.genres.map   { $0.name },
                        casts   : response.credits.cast
                            .lazy
                            .filter { cast in cast.character != nil }
                            .map    { cast in
                                Details.ViewModel.Cast(
                                    name     : cast.name,
                                    character: cast.character!,
                                    profile  : cast.profile.map { ApiRouter.getImageUrl(path: $0, forType: .profile) }
                                )
                            }
                    )
                    
                    self?.output.hideLoading()
                    self?.output.showSuccess(viewModel)
                }
            )
            .store(in: &cancellables)

    }
}
