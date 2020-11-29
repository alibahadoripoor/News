//
//  NewsViewModel.swift
//  News
//
//  Created by Ali Bahadori on 08.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

final class NewsListViewModel {
    
    //MARK: Constants and Variables
    
    var coordinator: NewsCoordinator?
    var webService: NewsServiceProtocol!
    var category: Category?
    var query: String?
    
    var onUpdateNews: () -> () = {}
    var onUpdateSearchNews: () -> () = {}
    var onShowAlert: (String, String?) -> () = { _,_ in }
    
    private var nextPage = 1
    var newsCells: [NewsCellViewModel] = []
    var isLastPage: Bool = true
    
    //MARK: Initializer
    
    init(webService: NewsServiceProtocol){
        self.webService = webService
    }
    
    //MARK: News Functions
    
    func viewDidLoad(){
        nextPage = 1
        
        if category != nil {
            webService.getHeadlines(
                for: category!, page: nextPage,
                completion: firstPageCompletionHandler(object: error:)
            )
        }
        
        if query != nil {
            webService.getEverything(
                with: query!, page: nextPage,
                completion: firstPageCompletionHandler(object: error:)
            )
        }
    }
    
    func viewDidScrollToBottom(){
        if category != nil {
            webService.getHeadlines(
                for: category!, page: nextPage,
                completion: otherPagesCompletionHandler(object: error:)
            )
        }
        
        if query != nil {
            webService.getEverything(
                with: query!, page: nextPage,
                completion: otherPagesCompletionHandler(object: error:)
            )
        }
    }
    
    func firstPageCompletionHandler(object: Object?, error: HTTPError?){
        guard error == nil else {
            onShowAlert("Network Error", error?.localizedDescription)
            return
        }
        
        guard let object = object, let articles = object.articles else { return }
        newsCells = articles.map({ NewsCellViewModel(article: $0) })
        
        if articles.count < 10{
            isLastPage = true
        }else{
            nextPage = 2
            isLastPage = false
        }
        
        onUpdateNews()
    }
    
    func otherPagesCompletionHandler(object: Object?, error: HTTPError?){
        guard error == nil else {
            onShowAlert("Network Error", error?.localizedDescription)
            return
        }
        
        guard let object = object, let articles = object.articles else { return }
        newsCells += articles.map({ NewsCellViewModel(article: $0) })
        
        if articles.count < 10{
            isLastPage = true
        }else{
            nextPage += 1
            isLastPage = false
        }
        
        onUpdateNews()
    }
    
    //MARK: Coordinator Functions
    
    func newsDidSelect(at index: Int){
        let news = newsCells[index]
        coordinator?.presentNewsDetailsViewController(with: news.url)
    }
    
    func viewDidDisappear(){
        coordinator?.didFinishNewsTableViewController()
    }
    
    deinit {
        debugPrint("deinit from News ViewModel")
    }
}
