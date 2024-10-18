//
//  ProductViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 06.10.2022.
//

import UIKit

class ProductViewController: UIViewController {
    var product: Product?
   // let cartVC = CartViewController()
    
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
    
    private lazy var image: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "tshirt"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemCyan
        button.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = product?.productTitle ?? "No"
        view.backgroundColor = .white
        descriptionLabel.text = product?.productDescription
        priceLabel.text = (product?.productPrice ?? "") + "$"
        image.image = product?.productImage
        
        view.addSubview(image)
        view.addSubview(scrollView)
        view.addSubview(priceLabel)
        scrollView.addSubview(descriptionLabel)
        view.addSubview(button)
        setupConstraints()
    }
    
    @objc private func addToCart() {
        //print("Add to cart item")
        let vc = tabBarController?.viewControllers?[1] as? CartViewController
        vc?.updateTableViewElements(product: product!)
        showAddCartAlert()
    }
    
    private func showAddCartAlert() {
        let alert = UIAlertController(
            title: "Product add!",
            message: "Item successfully added to cart!",
            preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func setupConstraints() {
        // image constraints
        image.heightAnchor.constraint(equalToConstant: 300).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor, constant: 115).isActive = true
        //image.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.frame.height/3)).isActive = true
        image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        // price constraints
        priceLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        priceLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 15).isActive = true
        //priceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        // button constraints
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //button.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -95).isActive = true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        // description constraints
//        descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -5).isActive = true
//        descriptionLabel.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -5).isActive = true
//        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
//        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        scrollView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -5).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -5).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 5).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -5).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: -1).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 1).isActive = true
    }
}
// MARK: - extensions
extension ProductViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
                scrollView.contentOffset.x = 0
            }
    }
}
