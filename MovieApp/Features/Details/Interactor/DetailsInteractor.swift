//
//  DetailsInteractor.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Combine
import Foundation

protocol DetailsInteractorInput {}

protocol DetailsInteractorOutput {}

final class DetailsInteractor: DetailsInteractorInput {
    
    let output: DetailsInteractorOutput
    let worker: DetailsWorkerProtocol
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ output: DetailsInteractorOutput, _ worker: DetailsWorkerProtocol) {
        self.output = output
        self.worker = worker
    }

}
