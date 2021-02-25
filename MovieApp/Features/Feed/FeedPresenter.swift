//
//  FeedPresenter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation

protocol FeedPresenterOutput {
    
}

final class FeedPresenter: FeedInteractorOutput {
    
    let output: FeedPresenterOutput
    
    init(_ output: FeedPresenterOutput) {
        self.output = output
    }
    
}
