//
//  TMDBAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

struct Media {
    let title: String
    let overview: String
    let rate: Double
    let poster: String
    let backPoster: String
    let ID: Int
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
    func callRequest(type: Endpoint, time: TimeWindow, cv: UICollectionView, resultMedia: @escaping ([Media]) -> Void) {
        let url = type.requestURL + time.endPoint
        var list: [Media] = []
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                                
                for item in json["results"].arrayValue {
                    let title = item["title"].stringValue
                    let overview = item["overview"].stringValue
                    let rate = item["vote_average"].doubleValue
                    let posterURL = "https://api.themoviedb.org" +  item["poster_path"].stringValue
                    let backPosterURL = "https://api.themoviedb.org" + item["backdrop_path"].stringValue
                    let mediaID = item["id"].intValue
                    let data = Media(title: title, overview: overview, rate: rate, poster: posterURL, backPoster: backPosterURL, ID: mediaID)
                    
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
