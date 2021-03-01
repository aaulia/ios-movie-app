//
//  DetailsPresenter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation

protocol DetailsPresenterOutput {
    func showSuccess(_ casts: [Details.ViewModel.Cast])
}

final class DetailsPresenter: DetailsInteractorOutput {
    
    let output: DetailsPresenterOutput
    
    init(_ output: DetailsPresenterOutput) {
        self.output = output
    }

    func showSuccess(_ casts: [Details.ViewModel.Cast]) { output.showSuccess(casts) }
    
}
