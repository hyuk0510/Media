//
//  TMDBAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Media {
    let title: String
    let overview: String
    let rate: Double
    let poster: String
    let backPoster: String
    let ID: Int
    let date: String
    let genre: String
}

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
    
    func callGenre(type: Endpoint, genreID: Int, resultGenre: @escaping (String) -> Void) {
        let genreURL = "https://api.themoviedb.org/3/genre/\(type)/list"
        
        AF.request(genreURL, method: .get,parameters: genreParameters, headers: self.headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (index, item) in json["genres"].arrayValue.enumerated() {
                    if item[index]["id"].intValue == genreID {
                        let genre = item[index]["name"].stringValue
                        print("===========", genre)
                        
                        resultGenre(genre)
                    }
                }
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    func callRequest(type: Endpoint, time: TimeWindow, cv: UICollectionView, resultMedia: @escaping ([Media]) -> Void) {
        let url = type.requestURL + time.endPoint
        let imageURL = "https://image.tmdb.org/t/p/w500"
        var list: [Media] = []
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["results"].arrayValue {
                    let title = item["title"].stringValue
                    let overview = item["overview"].stringValue
                    let rate = item["vote_average"].doubleValue
                    let posterURL = imageURL +  item["poster_path"].stringValue
                    let backPosterURL = imageURL + item["backdrop_path"].stringValue
                    let mediaID = item["id"].intValue
                    let date = item["release_date"].stringValue
                    let genreID = item["genre_ids"][0].intValue
                    var genre = ""
                    
                    self.callGenre(type: type, genreID: genreID) { result in
                        genre = result
                    }
                    
                    let data = Media(title: title, overview: overview, rate: rate, poster: posterURL, backPoster: backPosterURL, ID: mediaID, date: date, genre: genre)
                    
                    list.append(data)
                }
                
                resultMedia(list)
                cv.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
