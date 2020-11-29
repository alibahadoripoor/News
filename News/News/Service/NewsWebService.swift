//
//  NewsService.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

typealias ObjectCompletion = (Object?, HTTPError?) -> ()

protocol NewsServiceProtocol: class {
    func getHeadlines(for category: Category, page: Int, completion: @escaping ObjectCompletion)
    func getEverything(with query: String, page: Int, completion: @escaping ObjectCompletion)
}

final class NewsWebService: NewsServiceProtocol {
    var dataService: DataServiceProtocol!
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }
    
    private var urlBuilder: URLComponents = {
        var urlBuilder = URLComponents()
        urlBuilder.scheme = EndPoints.scheme
        urlBuilder.host = EndPoints.host
        return urlBuilder
    }()
    
    func getHeadlines(for category: Category, page: Int, completion: @escaping ObjectCompletion){
        urlBuilder.path = EndPoints.headlinesPath
        urlBuilder.queryItems = [
            URLQueryItem(name: "apiKey", value: EndPoints.apiKey),
            URLQueryItem(name: "pageSize", value: EndPoints.pageSize),
            URLQueryItem(name: "country", value: EndPoints.country),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "category", value: category.rawValue)
        ]
        
        guard let url = urlBuilder.url else { return }
        getNews(for: url, completion: completion)
    }
    
    func getEverything(with query: String, page: Int, completion: @escaping ObjectCompletion){
        urlBuilder.path = EndPoints.everythingPath
        urlBuilder.queryItems = [
            URLQueryItem(name: "apiKey", value: EndPoints.apiKey),
            URLQueryItem(name: "pageSize", value: EndPoints.pageSize),
            URLQueryItem(name: "language", value: EndPoints.language),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "q", value: query)
        ]
        
        guard let url = urlBuilder.url else { return }
        getNews(for: url, completion: completion)
    }
    
    private func getNews(for url: URL, completion: @escaping ObjectCompletion){
        dataService.fetchData(for: url) { (data, err) in
            
            guard err == nil else{
                completion(nil, err)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let object: Object = try decoder.decode(Object.self, from: data)
                completion(object, nil)
            } catch {
                debugPrint("Unable to decode data: \(error.localizedDescription)")
                completion(nil, .invalidData)
            }
        }
    }
}
