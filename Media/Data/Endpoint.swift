//
//  Endpoint.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import Foundation

enum Endpoint: String {
    case all
    case movie
    case person
    case tv
    
    var requestURL: String {
        switch self {
        case .all, .movie, .person, .tv: return URL.makeEndpoint("/\(self.rawValue)")
        }
    }
}

enum TimeWindow: String {
    case day
    case week
    
    var endPoint: String {
        switch self {
        case .day, .week: return "/\(self.rawValue)"
        }
    }
}

