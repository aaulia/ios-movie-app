//
//  ApiRouter.swift
//  MovieApp
//
//  Created by Ahmad Aulia Noorhakim on 25/02/21.
//

import Foundation
import Alamofire
import Combine

protocol Route: URLRequestConvertible {
    var method    : HTTPMethod  { get }
    var path      : String      { get }
    var parameters: Parameters? { get }
}

struct ApiRoute {
    
    enum TMDB: Route {
        case nowPlaying
        case popular
        case topRated
        case upcoming

        
        var method: HTTPMethod {
            switch self {
            case .nowPlaying,
                 .popular,
                 .topRated,
                 .upcoming:
                
                return .get
            }
        }
        
        var path: String {
            switch self {
            case .nowPlaying: return "/movie/now_playing"
            case .popular   : return "/movie/popular"
            case .topRated  : return "/movie/top_rated"
            case .upcoming  : return "/movie/upcoming"
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .nowPlaying,
                 .popular,
                 .topRated,
                 .upcoming:
                
                return [
                    "api_key" : ApiConstants.TMDB.apiKey,
                    "region"  : ApiConstants.TMDB.regionCode,
                    "language": ApiConstants.TMDB.languageCode,
                    "page"    : 1
                ]
            }
        }

        
        func asURLRequest() throws -> URLRequest {
            guard var components = URLComponents(
                    url: ApiConstants.TMDB.baseUrl.appendingPathComponent(self.path),
                    resolvingAgainstBaseURL: false
            ) else { throw ApiError.malformedUrl }
            
            if let parameters = self.parameters, !parameters.isEmpty {
                components.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 as? String) }
            }
            
            do {
                return try URLRequest(url: components.url!, method: self.method)
            } catch _ {
                throw ApiError.malformedUrl
            }
        }
    }
    
}

struct ApiRouter {
    
    static func request<T: Codable>(_ route: Route, ofType: T.Type) -> AnyPublisher<T, AFError> {
        return Deferred {
            Future { promise in
                AF.request(route).responseDecodable(of: ofType) { response in
                    promise(response.result)
                }
            }
        }.eraseToAnyPublisher()
    }

}
