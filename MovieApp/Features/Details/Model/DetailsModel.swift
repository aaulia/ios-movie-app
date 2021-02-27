//
//  DetailModel.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 27/02/21.
//

import Foundation

struct Details {
    
    struct Request {
        let movieId: Int
    }
    
    struct Response: Codable {
        let title   : String
        let overview: String
        let rating  : Float?
        let poster  : String?
        let backdrop: String?
        let genres  : [Genre]
        let credits : Credits
        
        enum CodingKeys: String, CodingKey {
            case title
            case overview
            case rating   = "vote_average"
            case poster   = "poster_path"
            case backdrop = "backdrop_path"
            case genres
            case credits
        }
        
        struct Genre: Codable {
            let name: String
        }
        
        struct Credits: Codable {
            let cast: [Cast]
            
            struct Cast: Codable {
                let name     : String
                let character: String?
                let profile  : String?
                
                enum CodingKeys: String, CodingKey {
                    case name
                    case character
                    case profile   = "profile_path"
                }
            }
        }
    }
    
    struct ViewModel {
        let title   : String
        let overview: String
        let rating  : Float?
        let poster  : URL?
        let backdrop: URL?
        let genres  : [String]
        let casts   : [Cast]
        
        struct Cast {
            let name     : String
            let character: String
            let profile  : URL?
        }
    }
}
