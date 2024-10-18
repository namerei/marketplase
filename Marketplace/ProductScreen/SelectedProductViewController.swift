//
//  ProductViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 06.10.2022.
//

import UIKit

class SelectedProductViewController: UIViewController {
    var selectedProduct: Product?
    
    // MARK: - UI Elements
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.textAlignment = .justified
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var productImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "tshirt"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = UIColor(named: "button")
        button.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        setupLayout()
    }
    
    // MARK: - Configuration
    private func configureView() {
        title = selectedProduct?.productTitle ?? "No Product"
        view.backgroundColor = .white
        descriptionLabel.text = selectedProduct?.productDescription
        priceLabel.text = (selectedProduct?.productPrice ?? "") + " $"
        productImageView.image = selectedProduct?.productImage
        
        view.addSubview(productImageView)
        view.addSubview(scrollView)
        view.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(addToCartButton)
    }
    
    @objc private func addToCartTapped() {
        guard let product = selectedProduct else { return }
        let cartVC = tabBarController?.viewControllers?[1] as? CartViewController
        cartVC?.updateTableViewElements(product: product)
        showCartAlert()
    }
    
    private func showCartAlert() {
        let alert = UIAlertController(
            title: "Product Added!",
            message: "Item successfully added to cart!",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Image View Constraints
            productImageView.heightAnchor.constraint(equalToConstant: 300),
            productImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 115),
            productImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Price Label Constraints
            priceLabel.heightAnchor.constraint(equalToConstant: 50),
            priceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 15),
            priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Scroll View Constraints
            scrollView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -5),
            scrollView.bottomAnchor.constraint(equalTo: addToCartButton.topAnchor, constant: -5),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            // Description Label Constraints
            descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5),
            descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -1),
            descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 1),
            
            // Button Constraints
            addToCartButton.heightAnchor.constraint(equalToConstant: 50),
            addToCartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95),
            addToCartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addToCartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}

// MARK: - UIScrollViewDelegate
extension SelectedProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
