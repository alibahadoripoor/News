//
//  SearchResultTableViewController.swift
//  News
//
//  Created by Ali Bahadori on 09.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {

    //MARK: Constants and Variables

    var viewModel: CategoryListViewModel!
    private let cellId = "cellId"
    private var bottomIndicator = UIActivityIndicatorView(style: .medium)

    //MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        //Notifications from View Model

        viewModel.onUpdateSearchHistories = { [weak self] in
            self?.tableView.tableFooterView?.isHidden = true
            self?.tableView.reloadData()
        }

    }

    deinit {
        debugPrint("deinit from Search Results TVC")
    }

    //MARK: Table View Delegate and Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchHistoryCells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        cell.textLabel?.text = viewModel.searchHistoryCells[indexPath.item].searchTitle
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.searchHistoryDidSelect(at: indexPath.item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

extension SearchResultsTableViewController{

    //MARK: Configure UI Functions

    private func setupTableView(){
        tableView.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.rowHeight = 50
        bottomIndicator.startAnimating()
        bottomIndicator.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        tableView.tableFooterView = bottomIndicator
        tableView.tableFooterView?.isHidden = true
    }
}
