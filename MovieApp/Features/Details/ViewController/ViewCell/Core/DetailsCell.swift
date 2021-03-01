//
//  DetailsSection.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import Foundation
import UIKit

protocol DetailsCell {
    func render(parentView: UIView, model: Details.ViewModel)
}
