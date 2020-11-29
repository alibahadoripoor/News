//
//  CategoriesTableViewController.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
    
    //MARK: Constants and Variables
    
    var viewModel: CategoryListViewModel!
    
    private let cellId = "cellId"
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSearchController()
        
        viewModel.viewDidLoad()
        
        //Notifications from View Model
        
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        
    }
    
    deinit {
        debugPrint("deinit from Categories TVC")
    }
    
    //MARK: Table View Delegate and Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        let categoryType = viewModel.cells[indexPath.item].rawValue
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = categoryType.uppercased()
        cell.imageView?.image = UIImage(named: categoryType)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.categoryDidSelect(at: indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension CategoriesTableViewController{
    
    //MARK: Configure UI Functions
    
    private func setupView(){
        title = "Categories"
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    private func setupSearchController() {
        let searchResultsTVC = SearchResultsTableViewController()
        searchResultsTVC.viewModel = viewModel
        let searchController = UISearchController(searchResultsController: searchResultsTVC)
        searchController.showsSearchResultsController = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
    }
}

extension CategoriesTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }
        viewModel.searchButtonDidSelect(with: text)
    }
}
