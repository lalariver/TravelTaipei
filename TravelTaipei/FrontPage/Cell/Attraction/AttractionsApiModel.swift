//
//  AttractionsModel.swift
//  TravelTaipei
//
//  Created by user on 2024/12/30.
//
//   let attractions = try? JSONDecoder().decode(Attractions.self, from: jsonData)

import Foundation

// MARK: - Attractions
struct AttractionsApiModel: Codable {
    var total: Int?
    var data: [Attraction]?
}

// MARK: - Datum
struct Attraction: Codable {
    var id: Int?
    var name: String?
    var openStatus: Int?
    var introduction, openTime, zipcode, distric: String?
    var address, tel: String?
    var fax: String?
    var email: String?
    var months: String?
    var nlat, elong: Double?
    var officialSite: String?
    var facebook: String?
    var ticket: String?
    var remind: String?
    var staytime: String?
    var modified: String?
    var url: String?
    var category, target, service, friendly: [Category]?
    var images: [Image]?
    var links: [Link]?
}

// MARK: - Category
struct Category: Codable {
    var id: Int?
    var name: String?
}

// MARK: - Image
struct Image: Codable {
    var src: String?
    var subject: String?
    var ext: String?
}

// MARK: - Link
struct Link: Codable {
    var src: String?
    var subject: String?
}
