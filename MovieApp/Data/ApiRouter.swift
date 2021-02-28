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
        
        case details(Int)
        case credits(Int)

        
        var method: HTTPMethod {
            switch self {
            case .nowPlaying,
                 .popular   ,
                 .topRated  ,
                 .upcoming  : return .get
                
            case .details(_),
                 .credits(_): return .get
                
            }
        }
        
        var path: String {
            switch self {
            case .nowPlaying: return "/movie/now_playing"
            case .popular   : return "/movie/popular"
            case .topRated  : return "/movie/top_rated"
            case .upcoming  : return "/movie/upcoming"
            
            case .details(let movieId): return "/movie/\(movieId)"
            case .credits(let movieId): return "/movie/\(movieId)/credits"
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
                
            case .details(_):
                return [
                    "api_key": ApiConstants.TMDB.apiKey,
                    "append_to_response": "credits"
                ]
                
            case .credits(_):
                return [
                    "api_key": ApiConstants.TMDB.apiKey,
                    "language": ApiConstants.TMDB.languageCode
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
    
    static func getImageUrl(path: String, forType type: ApiConstants.TMDB.ImageType) -> URL {
        return try! "\(ApiConstants.TMDB.imgUrl)\(type.size)\(path)".asURL()
    }
    
}
