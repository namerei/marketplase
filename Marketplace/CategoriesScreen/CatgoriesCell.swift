//
//  CatgoriesCell.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 29.09.2022.
//

import UIKit

struct CategoryCell {
    var iconCategory: String
    var description: String
    var jsonRequest: String
}

class CategoriesCell: UICollectionViewCell {
    
    private lazy var iconCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .black
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var descriptionCategoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        //translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(iconCategoryLabel)
        contentView.addSubview(descriptionCategoryLabel)
        backgroundColor = .systemGray6
        
        setupView()
        
    }
    
    private func setupView() {
        iconCategoryLabel.frame = CGRect(x: 0,
                                         y: contentView.frame.size.height - 105,
                                         width: contentView.frame.size.width,
                                         height: 50)
        descriptionCategoryLabel.frame = CGRect(x: 0,
                                                y: contentView.frame.size.height - 60,
                                                width: contentView.frame.size.width ,
                                                height: 50)
        layer.cornerRadius = 20
    }
    
    func configure(_ viewModel: CategoryCell) {
        iconCategoryLabel.text = viewModel.iconCategory
        descriptionCategoryLabel.text = viewModel.description
        //print(viewModel.iconCategory)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not be implemented")
    }
}

