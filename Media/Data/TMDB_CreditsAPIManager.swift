//
//  TMDB_CreditsAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/13.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Actor {
    let name: String
    let character: String
    let actorImage: String
}

class TMDB_CreditsAPIManager {
    
    static let shared = TMDB_CreditsAPIManager()
    
    private init() {}
    
    let headers: HTTPHeaders = [
      "accept": "application/json",
      "Authorization": "Bearer \(APIKey.TMDBReadToken)"
    ]
    let queryParameters: Parameters = [
        "language": "en-US"
    ]
    func callRequest(mediaID: Int, tv: UITableView, resultActor: @escaping ([Actor]) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(mediaID)/credits"
        var list: [Actor] = []
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["cast"].arrayValue {
                    let name = item["name"].stringValue
                    let character = item["character"].stringValue
                    let actorImage = url + item["profile_path"].stringValue
                    let data = Actor(name: name, character: character, actorImage: actorImage)
                    
                    list.append(data)
                    
                    
                }
                resultActor(list)
                tv.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
