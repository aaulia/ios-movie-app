//
//  FeedInteractor.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation

protocol FeedInteractorInput {
    
}

protocol FeedInteractorOutput {
    
}

final class FeedInteractor: FeedInteractorInput {
    
    let output: FeedInteractorOutput
    let worker: FeedWorkerProtocol
    
    init(_ output: FeedInteractorOutput, _ worker: FeedWorkerProtocol) {
        self.output = output
        self.worker = worker
    }
}
