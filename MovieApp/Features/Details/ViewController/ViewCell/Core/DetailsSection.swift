//
//  DetailsSection.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 28/02/21.
//

import Foundation
import UIKit

protocol DetailsSection {
    var maxWidth: CGFloat? { get set }

    func setup(collectionView: UICollectionView, model: DetailsSectionModel)
}
