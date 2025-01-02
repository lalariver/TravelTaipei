//
//  NewsCellModel.swift
//  TravelTaipei
//
//  Created by user on 2024/12/31.
//

import Foundation

struct NewsCellModel {
    var title: String?
    var subtitle: String?
    
    var urlString: String?
    
    init(newsData: NewsData) {
        self.title = newsData.title
        self.subtitle = newsData.description
        
        self.urlString = newsData.url
    }
}
