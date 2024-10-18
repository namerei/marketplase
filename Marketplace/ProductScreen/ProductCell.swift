//
//  ProductsCell.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 04.10.2022.
//

import UIKit

class ProductCell: UITableViewCell {
    
    // MARK: - UI Elements
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "tshirt"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setupImageViewConstraints(imageView)
        imageView.layer.cornerRadius = 115 // Половина высоты и ширины (230 / 2)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(productImageView)
        stack.addArrangedSubview(priceLabel)
        return stack
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with product: Product) {
        titleLabel.text = product.productTitle
        priceLabel.text = "\(product.productPrice) $"
        productImageView.image = product.productImage
    }

    // MARK: - Layout Setup
    private func setupCellLayout() {
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    private func setupImageViewConstraints(_ imageView: UIImageView) {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 230),
            imageView.heightAnchor.constraint(equalToConstant: 230)
        ])
    }
}
