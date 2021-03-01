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
        let casts: [Cast]
        
        enum CodingKeys: String, CodingKey {
            case casts = "cast"
        }
        
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
    
    struct ViewModel {
        let id      : Int
        let title   : String
        let overview: String
        let rating  : Float?
        let poster  : URL?
        let backdrop: URL?
        let casts   : [Cast]
        
        struct Cast {
            let name     : String
            let character: String
            let profile  : URL?
        }
        
        
        func copy(
            id      : Int?    = nil,
            title   : String? = nil,
            overview: String? = nil,
            rating  : Float?  = nil,
            poster  : URL?    = nil,
            backdrop: URL?    = nil,
            casts   : [Cast]? = nil
        ) -> ViewModel {
            return ViewModel(
                id      : id       ?? self.id,
                title   : title    ?? self.title,
                overview: overview ?? self.overview,
                rating  : rating   ?? self.rating,
                poster  : poster   ?? self.poster,
                backdrop: backdrop ?? self.backdrop,
                casts   : casts    ?? self.casts
            )
        }
    }
}
