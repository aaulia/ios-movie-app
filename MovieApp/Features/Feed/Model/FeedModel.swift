//
//  FeedModel.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 26/02/21.
//

import Foundation

struct Feed {
    
    struct Request {
        let feedType: FeedType
    }
    
    struct Response: Codable {
        let results: [Movie]
        
        struct Movie: Codable {
            let title: String
            let image: String?
            
            enum CodingKeys: String, CodingKey {
                case title
                case image = "poster_path"
            }
        }
    }
    
    struct ViewModel {
        let movies: [Movie]
        
        struct Movie {
            let title: String
            let image: URL?
        }
    }
    
}
