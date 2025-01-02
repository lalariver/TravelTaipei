//
//  AttractionCellModel.swift
//  TravelTaipei
//
//  Created by user on 2024/12/31.
//

import Foundation

struct AttractionCellModel {
    var imageUrl: String?
    var title: String?
    var subtitle: String?
    
    var openTiem: String?
    var address: String?
    var displayTel: String?
    var url: String?
    
    init(attraction: Attraction) {
        self.imageUrl = attraction.images?.first?.src
        self.title = attraction.name
        self.subtitle = attraction.introduction
        
        self.openTiem = attraction.openTime
        self.address = attraction.address
        self.displayTel = attraction.tel
        self.url = attraction.url
    }
}

extension AttractionCellModel {
    var tel: String? {
        return displayTel?.replacing("-", with: "")
    }
}
