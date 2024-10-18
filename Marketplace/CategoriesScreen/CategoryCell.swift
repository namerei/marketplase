//
//  CatgoriesCell.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 29.09.2022.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    private lazy var categoryIconLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .black
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    private lazy var categoryDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        contentView.addSubview(categoryIconLabel)
        contentView.addSubview(categoryDescriptionLabel)
        backgroundColor = UIColor(named: "background")
        layer.cornerRadius = 20
        clipsToBounds = true
    }
    
    private func setupLayout() {
        categoryIconLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryIconLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentView.frame.height - 105),
            categoryIconLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryIconLabel.heightAnchor.constraint(equalToConstant: 50),
            
            categoryDescriptionLabel.topAnchor.constraint(equalTo: categoryIconLabel.bottomAnchor, constant: 10),
            categoryDescriptionLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            categoryDescriptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configure(with viewModel: Category) {
        categoryIconLabel.text = viewModel.iconCategory
        categoryDescriptionLabel.text = viewModel.description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
