//
//  TMDB_CreditsAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/13.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    func callRequest(mediaID: Int, resultActor: @escaping ([Cast]) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(mediaID)/credits"
        
        AF.request(url, method: .get, parameters: queryParameters, headers: headers).validate().responseDecodable(of: Actor.self) { response in
                
            guard let value = response.value else { return }
            
            resultActor(value.cast)
        }
        
    }
}
