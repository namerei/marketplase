//
//  CartProductCell.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 06.10.2022.
//

import UIKit

class CartProductCell: UITableViewCell {
    
    private lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "tshirt"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        image.widthAnchor.constraint(equalToConstant: contentView.frame.width/4).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        priceLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/4).isActive = true
        priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        
        titleLabel.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
    }
    
    func configure(_ viewModel: ProductData) {
        titleLabel.text = viewModel.productTitle
        priceLabel.text = (viewModel.productPrice ?? "") + "$"
        image.image = UIImage(data: viewModel.productImage ?? Data())
    }
}
