//
//  TMDBConstants.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import Foundation

struct ApiConstants {
    
    struct TMDB {
        static let apiUrl = "https://api.themoviedb.org"
        static let apiVer = "3"
        static let apiKey = { () -> String in
            var apiKey = ""
            
            if let path = Bundle.main.path(forResource: "TMDB", ofType: "plist"),
               let data = NSDictionary(contentsOfFile: path) as? [String: Any] {
                
                apiKey = data["API_KEY"] as? String ?? ""
            }
            
            if apiKey.isEmpty { fatalError("Missing API Key") }
            
            return apiKey
        }()

        static let baseUrl      = try! "\(apiUrl)/\(apiVer)".asURL()
        static let regionCode   = Locale.current.regionCode ?? "US"
        static let languageCode = "\(Locale.current.languageCode ?? "en")-\(regionCode)"
    }
    
}
