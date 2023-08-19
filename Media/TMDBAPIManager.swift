//
//  TMDBAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() {}
    
    let headers: HTTPHeaders = [
      "accept": "application/json",
      "Authorization": "Bearer \(APIKey.TMDBReadToken)"
    ]
    let queryParameters: Parameters = [
        "language": "en-US"
    ]
    let genreParameters: Parameters = [
        "language": "en"
    ]
    let similarParameters: Parameters = [
        "language": "en-US",
        "page": 1
    ]
    var genre = ""
    
    func callGenre(type: Endpoint, genreID: [Int], resultGenre: @escaping ([GenreElement]) -> Void) {
        let genreURL = "https://api.themoviedb.org/3/genre/\(type)/list"
        
        AF.request(genreURL, method: .get,parameters: genreParameters, headers: self.headers).validate().responseDecodable(of: Genre.self) { response in
            
            guard let value = response.value else { return }
            
            resultGenre(value.genres)
        }
    }
    
    func callRequest(type: Endpoint, time: TimeWindow, resultMedia: @escaping ([Result], [GenreElement]) -> Void) {
        let url = type.requestURL + time.endPoint
        var genreID: [Int] = []
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseDecodable(of: Media.self) { response in
                        
            guard let value = response.value else { return }
                        
            for item in value.results {
                genreID.append(item.genreIDS[0])
            }
            
            self.callGenre(type: type, genreID: genreID) { response in
                resultMedia(value.results, response)
            }

        }
    }
    
    func callActor(mediaID: Int, resultActor: @escaping (Actor) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(mediaID)/credits"
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseDecodable(of: Actor.self) { response in
                
            guard let value = response.value else { return }
            
            resultActor(value)
        }
    }
    
    func callSimilar(movieID: Int, resultSimilar: @escaping ([SimilarResult]) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieID)/similar"

        AF.request(url, method: .get, parameters: similarParameters, headers: headers).validate().responseDecodable(of: Similar.self) { response in
            
            guard let value = response.value else { return }
            resultSimilar(value.results)
        }
    }
}
