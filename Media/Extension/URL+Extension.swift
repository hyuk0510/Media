//
//  URL+Extension.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import Foundation

extension URL {
    static let baseURL = "https://api.themoviedb.org/3/trending"
    
    static func makeEndpoint(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
