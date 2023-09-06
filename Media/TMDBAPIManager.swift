//
//  TMDBAPIManager.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Alamofire

class TMDBAPIManager {
    static let shared = TMDBAPIManager()
    
    private init() {}
    
    let scheme = "https"
    let host = "api.themoviedb.org"
    let key = "Bearer \(APIKey.TMDBReadToken)"

    let headers: HTTPHeaders = [
      "accept": "application/json",
      "Authorization": "Bearer \(APIKey.TMDBReadToken)"
    ]
    let queryParameters: Parameters = [
        "language": "en-US"
    ]
    let similarParameters: Parameters = [
        "language": "en-US",
        "page": 1
    ]
    var genre = ""
    
    func callGenre(type: Endpoint, genreID: [Int], resultGenre: @escaping (Genre) -> Void) {
        let path = "/3/genre/\(type)/list"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "language", value: "en")
        ]
        
        guard let url = component.url else { return }
        
        var requestURL = URLRequest(url: url)
        
        requestURL.httpMethod = "GET"
        requestURL.addValue("application/json", forHTTPHeaderField: "accept")
        requestURL.addValue(key, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            if let _ = error {
                print("ERROR")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("SERVER ERROR")
                return
            }
            
            if let data = data, let genreData = try? JSONDecoder().decode(Genre.self, from: data) {
                resultGenre(genreData)
                return
            }
            
        }.resume()
        
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
                resultMedia(value.results, response.genres)
            }

        }
    }
    
    func callCredit(mediaID: Int, resultCredit: @escaping (Credit) -> Void) {
        let path = "/3/movie/\(mediaID)/credits"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        
        guard let url = component.url else { return }
        
        var requestURL = URLRequest(url: url)
        
        requestURL.httpMethod = "GET"
        requestURL.addValue("application/json", forHTTPHeaderField: "accept")
        requestURL.addValue(key, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            if let _ = error {
                print("ERROR")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("SERVER ERROR")
                return
            }
            
            if let data = data, let creditData = try? JSONDecoder().decode(Credit.self, from: data) {
                resultCredit(creditData)
                return
            }
            
        }.resume()
        
    }
    
    func callSimilar(movieID: Int, resultSimilar: @escaping (Similar) -> Void) {
        let path = "/3/movie/\(movieID)/similar"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: "1")
        ]
        
        guard let url = component.url else { return }
        
        var requestURL = URLRequest(url: url)
        
        requestURL.httpMethod = "GET"
        requestURL.addValue("application/json", forHTTPHeaderField: "accept")
        requestURL.addValue(key, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            
            if let _ = error {
                print("ERROR")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("SERVER ERROR")
                return
            }
            
            if let data = data, let similarData = try? JSONDecoder().decode(Similar.self, from: data) {
                resultSimilar(similarData)
                return
            }
            
        }.resume()
        
    }
}
