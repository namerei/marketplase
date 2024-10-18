//
//  ProductViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 04.10.2022.
//

import Foundation
import UIKit

class CategoryProductViewController: UIViewController {
    let cellID: String = "CategoryProduct"
    var categoryTitle: String?
    var products: [Product] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .systemGray4
        tableView.rowHeight = view.frame.height/2
        
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(frame: CGRect(x: view.frame.width/2 - 75, y: 40, width: 150, height: 150))
        return indicator
    }()
// MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = categoryTitle ?? "No category"
        view.backgroundColor = .white
        
        tableView.register(ProductsCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupContstraints()
    }
    
    private func setupContstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func productDownload(urlString: String) {
        activityIndicator.startAnimating()
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = ["accept": "application/json"]
        
        let task = URLSession.shared.dataTask(
            with: request) {
                data, response, error in
                DispatchQueue.global().async {
                    [weak self] in
                    guard let self = self else { return }
                    print("async")
                    if let error = error {
                        print(error)
                    } else {
                        print("try")
                        if let data = data,
                           let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                            print("Yes!")
                                print("Succes")
                                var index: Int = 0
                                for product in json {
                                    self.products.append(Product(productTitle: "",
                                                            productPrice: "",
                                                            productDescription: "",
                                                            productURLImage: "",
                                                            productImage: UIImage()
                                                                ))
                                    if let title = product["title"] as? String {
                                        self.products[index].productTitle = title
                                    }
                                    if let description = product["description"] as? String {
                                        self.products[index].productDescription = description
                                    }
                                    if let price = product["price"] as? Double {
                                        self.products[index].productPrice = String(price)
                                    }
                                    if let imageURL = product["images"] as? [String] {
                                        self.products[index].productURLImage = imageURL[0]
                                    }
                                    index += 1
                                }
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.loadImages()
                            }
                        }
                    }
                }
                
            }
        task.resume()
    }
    
    private func loadImages() {
        let dispatchGroup = DispatchGroup()
        view.addSubview(activityIndicator)
        for index in 0...(products.count - 1) {
            dispatchGroup.enter()
            
            asyncLoadImage(imageStringURL: products[index].productURLImage,
                           runQueue: DispatchQueue.global(),
                           completionQueue: DispatchQueue.main) { result, error in
                guard let image = result else {return}
                self.products[index].productImage = image
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else {return}
            print("notify")
            self.activityIndicator.stopAnimating()
            self.activityIndicator.removeFromSuperview()
            self.tableView.reloadData()
        }
    }
    private func asyncLoadImage(
        imageStringURL: String,
        runQueue: DispatchQueue,
        completionQueue: DispatchQueue,
        completion: @escaping (UIImage?, Error?) -> ()
    ){
        runQueue.async {
            do {
                let image = self.downloadImage(urlString: imageStringURL)
                print("___image url:", imageStringURL)
                completionQueue.async { completion(image, nil) }
                }
        }
    }
    private func downloadImage(urlString: String) -> UIImage? {
        guard
            let url = URL(string: urlString),
            let data = try? Data(contentsOf: url)
        else {
            print("Ошибка, не удалось загрузить изображение")
            print(urlString)
            return nil
        }
        
        return UIImage(data: data)
    }
}
// MARK: - TableViewDelegate
extension CategoryProductViewController: UITableViewDelegate {
    
}
// MARK: - TableViewDataSource
extension CategoryProductViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? ProductsCell
        let viewModel = products[indexPath.row]
        cell?.configure(viewModel)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productVC = ProductViewController()
        productVC.product = products[indexPath.row]
        navigationController?.pushViewController(productVC,
                                                 animated: true)
    }
}
