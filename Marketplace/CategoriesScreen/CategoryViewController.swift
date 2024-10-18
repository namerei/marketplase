//
//  ViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 28.09.2022.
//

import UIKit

class CategoryViewController: UIViewController {
    let baseURL = "https://api.escuelajs.co/api/v1/categories/"

    let categories: [CategoryCell] = [
        CategoryCell(iconCategory: "👕",
                     description: "Clothes",
                     jsonRequest: "1/products")
        ,
        CategoryCell(iconCategory: "🪑",
                     description: "Furniture",
                     jsonRequest: "3/products"
                    ),
        CategoryCell(iconCategory: "🖥",
                     description: "Electronics",
                     jsonRequest: "2/products"),
        CategoryCell(iconCategory: "👟",
                     description: "Shoes",
                     jsonRequest: "4/products"),
        CategoryCell(iconCategory: "🚲",
                     description: "Miscellaneous",
                     jsonRequest: "5/products")
    ]
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 10

        // Рассчитываем размер для двух столбцов
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

