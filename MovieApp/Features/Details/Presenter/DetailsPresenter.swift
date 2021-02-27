//
//  DetailsPresenter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation

protocol DetailsPresenterOutput {
    func showLoading()
    func hideLoading()
    func showFailure(_ error: Error)
    func showSuccess(_ model: Details.ViewModel)
}

final class DetailsPresenter: DetailsInteractorOutput {
    
    let output: DetailsPresenterOutput
    
    init(_ output: DetailsPresenterOutput) {
        self.output = output
    }

    func showLoading() { output.showLoading() }
    
    func hideLoading() { output.hideLoading() }

    func showFailure(_ error: Error) {
        output.showFailure(error)
    }

    func showSuccess(_ model: Details.ViewModel) {
        output.showSuccess(model)
    }
}
