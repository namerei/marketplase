//
//  ProductViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 04.10.2022.
//

import Foundation
import UIKit

class ProductsInCategoryViewController: UIViewController {
    private let cellIdentifier: String = "ProductCell"
    var selectedCategoryTitle: String?
    private var productList: [Product] = []

    // MARK: - UI Elements
    private lazy var productTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemGray4
        tableView.rowHeight = view.frame.height / 2.3
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.center = view.center
        return indicator
    }()

    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewController()
        setupTableView()
    }
    
    private func setupViewController() {
        title = selectedCategoryTitle ?? "No Category"
        view.backgroundColor = .white
        view.addSubview(productTableView)
        view.addSubview(loadingIndicator)
        setupConstraints()
    }
    
    private func setupTableView() {
        productTableView.register(ProductCell.self, forCellReuseIdentifier: cellIdentifier)
        productTableView.delegate = self
        productTableView.dataSource = self
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTableView.topAnchor.constraint(equalTo: view.topAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    
    // MARK: - Networking
    func loadProducts(from urlString: String) {
        loadingIndicator.startAnimating()
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["Accept": "application/json"]

        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching data: \(error)")
                return
            }

            self.handleResponse(data: data)
        }
        task.resume()
    }

    private func handleResponse(data: Data?) {
        guard let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                self.productList = json.compactMap { self.parseProduct(from: $0) }
                DispatchQueue.main.async {
                    self.loadingIndicator.stopAnimating()
                    self.productTableView.reloadData()
                    self.loadProductImages()
                }
            }
        } catch {
            print("JSON parsing error: \(error)")
        }
    }

    private func parseProduct(from json: [String: Any]) -> Product? {
        let title = json["title"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let price = String(describing: json["price"] as? Double ?? 0.0)
        let imageURLs = json["images"] as? [String] ?? []
        let imageURL = imageURLs.first ?? ""

        return Product(productTitle: title,
                       productPrice: price,
                       productDescription: description,
                       productURLImage: imageURL,
                       productImage: UIImage())
    }

    private func loadProductImages() {
        let dispatchGroup = DispatchGroup()
        
        for index in 0..<productList.count {
            dispatchGroup.enter()
            loadImage(for: productList[index].productURLImage) { [weak self] image in
                self?.productList[index].productImage = image!
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.productTableView.reloadData()
        }
    }

    private func loadImage(for imageURL: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let noImageURL = "https://i.imgur.com/uqoohRT.png"
            let validURL = imageURL.first == "[" ? noImageURL : imageURL
            
            if let url = URL(string: validURL),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Error downloading image from URL: \(validURL)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate
extension ProductsInCategoryViewController: UITableViewDelegate {
    // Implement any delegate methods if needed
}

// MARK: - UITableViewDataSource
extension ProductsInCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ProductCell
        let viewModel = productList[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        productList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailVC = SelectedProductViewController()
        productDetailVC.selectedProduct = productList[indexPath.row]
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
