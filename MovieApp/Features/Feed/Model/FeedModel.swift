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
            let id      : Int
            let title   : String
            let overview: String
            let rating  : Float?
            let poster  : String?
            let backdrop: String?

            enum CodingKeys: String, CodingKey {
                case id
                case title
                case overview
                case rating   = "vote_average"
                case poster   = "poster_path"
                case backdrop = "backdrop_path"
            }
        }
    }
    
    struct ViewModel {
        let movies: [Movie]
        
        struct Movie {
            let id      : Int
            let title   : String
            let overview: String
            let rating  : Float?
            let poster  : URL?
            let backdrop: URL?
        }
    }
    
}
