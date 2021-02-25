//
//  FeedConstants.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import Foundation

protocol FeedConfiguration {
    var name: String { get }
    var icon: String { get }
}

enum FeedType : FeedConfiguration {
    case nowPlaying
    case popular
    case topRated
    case upcoming

    var name: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        case .topRated:
            return "Top Rated"
        case .upcoming:
            return "Upcoming"
        }
    }
    
    var icon: String {
        switch self {
        case .nowPlaying:
            return "icon_now_playing"
        case .popular:
            return "icon_popular"
        case .topRated:
            return "icon_top_rated"
        case .upcoming:
            return "icon_upcoming"
        }
    }
    
}
