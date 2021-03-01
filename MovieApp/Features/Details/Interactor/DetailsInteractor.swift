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
    func showSuccess(_ casts: [Details.ViewModel.Cast])
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
        worker.fetchCredits(movieId: id)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): debugPrint(error)
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
                
                    self?.output.showSuccess(Array(casts))
                }
            )
            .store(in: &cancellables)
    }
}
