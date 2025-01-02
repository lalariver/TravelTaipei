//
//  NewsModel.swift
//  TravelTaipei
//
//  Created by user on 2024/12/31.
//

import Foundation

// MARK: - News
struct NewsApiModel: Codable {
    var total: Int?
    var data: [NewsData]?
}

// MARK: - Datum
struct NewsData: Codable {
    var id: Int?
    var title, description: String?
    var posted, modified: String?
    var url: String?
    var files: [File]?
    var links: [Link]?
}

// MARK: - File
struct File: Codable {
    var src: String?
    var subject: String?
    var ext: String?
}

// MARK: - Link
