//
//  TraveTaipeiApi.swift
//  TravelTaipei
//
//  Created by user on 2024/12/30.
//

import Foundation

enum TravelTaipeiApi {
    case attractionsAll(page: String)
    case eventsNews(page: String)
    
    var baseURL: String {
        return "https://www.travel.taipei/open-api/"
    }
        
    var path: String {
        switch self {
        case .attractionsAll:
            return "/Attractions/All"
        case .eventsNews:
            return "/Events/News"
        }
    }
    
    var lang: String {
        return LocalizationManager.shared.getCurrentLangCode()
    }
    
    var method: String {
        switch self {
        case .attractionsAll(page: _):
            return "GET"
        case .eventsNews(page: _):
            return "GET"
        }
    }
    
    var headers: [String: String] {
        return [
            "accept": "application/json"
        ]
    }
    
    var parameters: [String: String]? {
        switch self {
        case .attractionsAll(page: let page):
            return ["page": page]
        case .eventsNews(page: let page):
            return ["page": page]
        }
    }
    
    var urlRequest: URLRequest {
        var components = URLComponents(string: baseURL + lang + path)!
        if let parameters = parameters {
            components.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            fatalError("Invalid URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        
        return request
    }
}
