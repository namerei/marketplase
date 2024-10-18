//
//  ViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 28.09.2022.
//

import UIKit

class CategoryViewController: UIViewController {
    let baseURL = "https://api.escuelajs.co/api/v1/categories/"
//    "https://fakestoreapi.com/products/category/\(viewModel.jsonRequest)"

    let categories: [CategoryCell] = [
        CategoryCell(iconCategory: "👕",
                     description: "Men's clothes",
                     jsonRequest: "5/products"),
        CategoryCell(iconCategory: "👚",
                     description: "Women's clothes",
                     jsonRequest: "3/products"
                    ),
        CategoryCell(iconCategory: "🖥",
                     description: "Electronics",
                     jsonRequest: "2/products"),
        CategoryCell(iconCategory: "💎",
                     description: "Shoes",
                     jsonRequest: "4/products")
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: (view.frame.width/2) + 100 ,
                                 height: view.frame.height/6)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Categories"
        view.backgroundColor = .white
        
        collectionView.register(CategoriesCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
        setupView()
    }

    private func setupView() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110).isActive = true
    }
}

// MARK: - Extensions
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewModel = categories[indexPath.row]
        print("Selected: \(viewModel.description)")
        
        let categoryProductViewController = CategoryProductViewController()
        categoryProductViewController.categoryTitle = viewModel.description
        categoryProductViewController.productDownload(
            urlString: baseURL + viewModel.jsonRequest)
        navigationController?.pushViewController(categoryProductViewController,
                                                 animated: true)
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoriesCell
        let viewModel = categories[indexPath.row]
        cell.configure(viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
}

