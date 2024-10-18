//
//  ViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 28.09.2022.
//

import UIKit

class CategoriesViewController: UIViewController {
    let baseURL = "https://api.escuelajs.co/api/v1/categories/"

    let categoryCells: [Category] = [
        Category(iconCategory: "👕", description: "Clothes", jsonRequest: "1/products"),
        Category(iconCategory: "🪑", description: "Furniture", jsonRequest: "3/products"),
        Category(iconCategory: "🖥", description: "Electronics", jsonRequest: "2/products"),
        Category(iconCategory: "👟", description: "Shoes", jsonRequest: "4/products"),
        Category(iconCategory: "🚲", description: "Miscellaneous", jsonRequest: "5/products")
    ]
    
    private lazy var categoriesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 10

        let numberOfColumns: CGFloat = 2
        let itemWidth = (view.frame.width - (layout.minimumInteritemSpacing * (numberOfColumns - 1)) - 32) / numberOfColumns
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.8)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupCollectionView()
        setupLayout()
    }

    private func setupViewController() {
        title = "Categories"
        view.backgroundColor = .white
    }

    private func setupCollectionView() {
        categoriesCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        view.addSubview(categoriesCollectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            categoriesCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -110)
        ])
    }
}

// MARK: - UICollectionViewDelegate
extension CategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = categoryCells[indexPath.row]
        print("Selected: \(selectedCategory.description)")
        
        let productsVC = ProductsInCategoryViewController()
        productsVC.selectedCategoryTitle = selectedCategory.description
        productsVC.loadProducts(from: baseURL + selectedCategory.jsonRequest)
        navigationController?.pushViewController(productsVC, animated: true)
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension CategoriesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = categoryCells[indexPath.row]
        cell.configure(with: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryCells.count
    }
}
