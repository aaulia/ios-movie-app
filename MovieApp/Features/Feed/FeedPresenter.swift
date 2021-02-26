//
//  FeedPresenter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation

protocol FeedPresenterOutput {
    func showLoading()
    func hideLoading()
    func showFailure(_ error: Error)
    func showSuccess(_ model: Feed.ViewModel)
}

final class FeedPresenter: FeedInteractorOutput {
    
    let output: FeedPresenterOutput
    
    init(_ output: FeedPresenterOutput) {
        self.output = output
    }

    func showLoading() { output.showLoading() }
    
    func hideLoading() { output.hideLoading() }

    func showFailure(_ error: Error) {
        output.showFailure(error)
    }

    func showSuccess(_ model: Feed.ViewModel) {
        output.showSuccess(model)
    }
}
