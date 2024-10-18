//
//  ProductsCell.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 04.10.2022.
//

import UIKit

struct Product {
    var productTitle: String
    var productPrice: String
    var productDescription: String
    var productURLImage: String
    var productImage: UIImage
}

class ProductsCell: UITableViewCell {
    
    private lazy var productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "tshirt"))
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.contentMode = .scaleToFill
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.addArrangedSubview(productTitleLabel)
        stackView.addArrangedSubview(productImage)
        stackView.addArrangedSubview(productPriceLabel)
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: Product) {
        print(viewModel.productTitle)
        productTitleLabel.text = viewModel.productTitle
        productPriceLabel.text = viewModel.productPrice + "$"
        productImage.image = viewModel.productImage
    }
    
}
