//
//  Category.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

enum Category: String {
    case business, entertainment, general, health, science, sports, technology
}


final class Object: Codable{
    var status: String!
    var totalResults: Int?
    var articles: [Article]?
    var code: String?
    var message: String?
}
 
final class Article: Codable{
    var source: Source!
    var title: String!
    var url: String!
    var urlToImage: String!
    var publishedAt: String!
}

final class Source: Codable{
    var name: String!
}
