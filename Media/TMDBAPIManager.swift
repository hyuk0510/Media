//
//  TMDBAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON

//struct Media {
//    let title: String
//    let overview: String
//    let rate: Double
//    let poster: String
//    let backPoster: String
//    let ID: Int
//    let date: String
//    let genre: String
//}

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
    var genre = ""
    
    func callGenre(type: Endpoint, genreID: [Int], resultGenre: @escaping ([GenreElement]) -> Void) {
        let genreURL = "https://api.themoviedb.org/3/genre/\(type)/list"
//        var genreResult: [String] = []
        
        AF.request(genreURL, method: .get,parameters: genreParameters, headers: self.headers).validate().responseDecodable(of: Genre.self) { response in
            
            guard let value = response.value else { return }
            
//            for item in value.genres {
//                for genre in genreID {
//                    if item.id == genre {
//                        genreResult.append(item.name)
//                    }
//                }
//            }
            
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
    
}
