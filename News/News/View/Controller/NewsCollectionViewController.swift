//
//  NewsCollectionViewController.swift
//  News
//
//  Created by Ali Bahadori on 08.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit

class NewsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Constants and Variables
    
    var viewModel: NewsListViewModel!
    private let cellId = "cellId"
    private let footerId = "footerId"
    private var topIndicator = UIRefreshControl()
    private var bottomIndicator = UIActivityIndicatorView(style: .medium)
    
    //MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        viewModel.viewDidLoad()
        
        //Notifications from View Model
        
        viewModel.onUpdateNews = { [weak self] in
            self?.topIndicator.endRefreshing()
            self?.bottomIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
        
        viewModel.onShowAlert = { [weak self] (title, des) in
            self?.showAlert(title, message: des ?? "")
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    deinit {
        debugPrint("deinit from News TVC")
    }
    
    //MARK: Collection View Delegate and Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newsCells.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCell
        cell.updateCell(with: viewModel.newsCells[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 20, height: view.frame.width - 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId, for: indexPath)
        footer.addSubview(bottomIndicator)
        bottomIndicator.frame = .init(x: 0, y: 0, width: view.frame.width, height: 60)
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.newsDidSelect(at: indexPath.item)
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if !viewModel.isLastPage, elementKind == UICollectionView.elementKindSectionFooter{
            bottomIndicator.startAnimating()
            viewModel.viewDidScrollToBottom()
        }
    }
    
    //MARK: Initializers
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NewsCollectionViewController{
    
    //MARK: Configure UI Functions
    
    private func setupCollectionView(){
        if let category = viewModel.category?.rawValue.uppercased(){
            title = category
        }else{
            title = "Search Results"
        }
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
        topIndicator.addTarget(self, action: #selector(reloadNews), for: .valueChanged)
        collectionView.refreshControl = topIndicator
    }
    
    @objc dynamic private func reloadNews(){
        viewModel.viewDidLoad()
    }
}
