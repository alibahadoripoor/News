//
//  CategoriesViewModel.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation
import CoreData

final class CategoryListViewModel: NSObject {
    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController<SearchHistory>!
    var coordinator: CategoriesCoordinator?
    var cells: [Category] = []
    var searchHistoryCells: [SearchHistory] = []
    var onUpdate: () -> () = {}
    var onUpdateSearchHistories: () -> () = {}
    
    init(dataController: DataController = DataController(modelName: "NewsDataModel")){
        self.dataController = dataController
    }
    
    ///This function calls by CategoriesTableViewController to detect when the controller is loaded.
    func viewDidLoad(){
        setupFetchedResultsController()
        loadSearchHistories()
        cells = [.business, .entertainment, .general, .health, .science, .sports, .technology]
        onUpdate()
    }
    
    func categoryDidSelect(at index: Int){
        let category = cells[index]
        coordinator?.startNewsTableViewController(category: category, query: nil)
    }
    
    func searchButtonDidSelect(with query: String){
        coordinator?.startNewsTableViewController(category: nil, query: query)
        addSearchHistory(title: query)
    }
    
    func searchHistoryDidSelect(at index: Int){
        let query = searchHistoryCells[index].searchTitle
        coordinator?.startNewsTableViewController(category: nil, query: query)
    }
    
    deinit {
        debugPrint("deinit from Categories ViewModel")
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: "SearchHistories")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func loadSearchHistories() {
        if let searchHistories = fetchedResultsController.fetchedObjects {
            searchHistoryCells = searchHistories
        }
    }
    
    private func addSearchHistory(title: String) {
        let searchHistory = SearchHistory(context: dataController.viewContext)
        searchHistory.searchTitle = title
        searchHistory.creationDate = Date()
        try? dataController.viewContext.save()
    }
}

extension CategoryListViewModel: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let searchHistory = anObject as? SearchHistory else {
            preconditionFailure("NOT A Search History!")
        }
        switch type {
        case .insert:
            searchHistoryCells.insert(searchHistory, at: 0)
            onUpdateSearchHistories()
            break
        default: ()
        }
    }
}
