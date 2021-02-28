//
//  DetailsInteractor.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Combine
import Foundation

protocol DetailsInteractorInput {
    func fetchCredits(movieId id: Int)
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

    func fetchCredits(movieId id: Int) {
        output.showLoading()
        worker.fetchCredits(movieId: id)
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): self?.output.showFailure(error)
                    }
                },
                receiveValue: { [weak self] response in
                    let casts = response.casts
                        .lazy
                        .filter { entry in entry.character != nil }
                        .map { entry in
                            Details.ViewModel.Cast(
                                name: entry.name,
                                character: entry.character!,
                                profile: entry.profile.map { ApiRouter.getImageUrl(path: $0, forType: .profile) }
                            )
                        }
                
                    self?.output.hideLoading()
                    self?.output.showSuccess(Details.ViewModel(casts: Array(casts)))
                }
            )
            .store(in: &cancellables)
    }
}
