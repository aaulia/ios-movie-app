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
        let casts: [Cast]
        
        struct Cast {
            let name     : String
            let character: String
            let profile  : URL?
        }
    }
}
