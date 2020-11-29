//
//  NewsCellViewModel.swift
//  News
//
//  Created by Ali Bahadori on 12.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

final class NewsCellViewModel {
    var article: Article
    
    var title: String{
        return article.title
    }
    
    var url: String{
        return article.url
    }
    
    var urlToImage: String?{
        return article.urlToImage
    }
    
    var sourceName: String{
        return article.source.name
    }
    
    var publishedAt: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: article.publishedAt) else { return "" }
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    init(article: Article) {
        self.article = article
    }
}
