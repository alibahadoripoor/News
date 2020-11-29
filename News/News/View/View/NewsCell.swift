//
//  NewsCell.swift
//  News
//
//  Created by Ali Bahadori on 08.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import UIKit
import Kingfisher

final class NewsCell: UICollectionViewCell {
    
    //MARK: Constants and Variables
    
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let hStackView = UIStackView()
    private let newsPublishDateLabel = UILabel()
    private let newsSourceLabel = UILabel()
    
    //MARK: Update Cell Function
    
    func updateCell(with news: NewsCellViewModel){
        newsTitleLabel.text = news.title
        newsPublishDateLabel.text = news.publishedAt
        newsSourceLabel.text = news.sourceName
        
        let placeholder = #imageLiteral(resourceName: "news")
        newsImageView.image = placeholder
        
        guard let urlStr = news.urlToImage, let url = URL(string: urlStr) else {
            return
        }
        
        let resource = ImageResource(downloadURL: url, cacheKey: news.urlToImage)
        newsImageView.kf.setImage(with: resource, placeholder: placeholder, options: [.transition(.fade(0.2))], progressBlock: nil) { _ in }
    }
    
    //MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Setup View Hierarchy
    
    private func setupHierarchy(){
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(hStackView)
        hStackView.addArrangedSubview(newsPublishDateLabel)
        hStackView.addArrangedSubview(newsSourceLabel)
    }
    
    //MARK: Setup View Layouts
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            newsImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            newsImageView.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.6),
            
            newsTitleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 8),
            newsTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newsTitleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newsTitleLabel.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.25),
            
            hStackView.topAnchor.constraint(equalTo: newsTitleLabel.bottomAnchor),
            hStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
            hStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
            hStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: Setup Views Functions
    
    private func setupViews(){
        setupCell()
        setupNewsImageView()
        setupNewsTitleLabel()
        setupHStackView()
    }
    
    private func setupCell(){
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 2
        
        if traitCollection.userInterfaceStyle == .dark{
            backgroundColor = .tertiarySystemBackground
            layer.shadowOpacity = 0.0
        }else{
            backgroundColor = .systemBackground
            layer.shadowOpacity = 0.6
        }
    }
    
    private func setupNewsImageView(){
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 5
        newsImageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner] /// Top right corner, Top left corner respectively
    }
    
    private func setupNewsTitleLabel(){
        newsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        newsTitleLabel.font = .boldSystemFont(ofSize: 20)
        newsTitleLabel.numberOfLines = 3
    }
    
    private func setupHStackView(){
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.axis = .horizontal
        hStackView.distribution = .fillEqually
        
        setupNewsPublishDateLabel()
        setupNewsSourceLabel()
    }
    
    private func setupNewsPublishDateLabel(){
        newsPublishDateLabel.font = .systemFont(ofSize: 14)
        newsPublishDateLabel.textColor = .systemGray2
    }
    
    private func setupNewsSourceLabel(){
        newsSourceLabel.font = .systemFont(ofSize: 14)
        newsSourceLabel.textColor = .systemGray2
        newsSourceLabel.textAlignment = .right
    }
    
    //MARK: Update Appearance
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.userInterfaceStyle == .dark{
            backgroundColor = .tertiarySystemBackground
            layer.shadowOpacity = 0.0
        }else{
            backgroundColor = .systemBackground
            layer.shadowOpacity = 0.6
        }
    }
}
