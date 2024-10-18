//
//  CartViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 29.09.2022.
//

import UIKit
import CoreData

class OrdersViewController: UIViewController {
    
    private let persistentContainer = NSPersistentContainer(name: "ProductDataStorage")
    private let cellIdentifier: String = "OrderCell"
    private var cartProducts: [Product] = []
    
    private lazy var ordersTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = .zero
        tableView.separatorColor = .systemGray4
        tableView.rowHeight = view.frame.height / 6
        return tableView
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<ProductData> = {
        let fetchRequest = ProductData.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "productTitle", ascending: true)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        controller.delegate = self
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Shopping Cart"
        
        setupTableView()
        setupConstraints()
        loadPersistentStore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ordersTableView.reloadData()
    }
    
    // MARK: - Setup Methods
    
    private func setupTableView() {
        ordersTableView.register(OrderCell.self, forCellReuseIdentifier: cellIdentifier)
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        view.addSubview(ordersTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            ordersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            ordersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            ordersTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            ordersTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Data Handling
    
    func updateCart(with product: Product) {
        cartProducts.append(product)
        saveProductToCoreData(product)
    }
    
    private func saveProductToCoreData(_ product: Product) {
        let productData = ProductData(entity: NSEntityDescription.entity(forEntityName: "ProductData", in: persistentContainer.viewContext)!, insertInto: persistentContainer.viewContext)
        productData.productImage = product.productImage.pngData()
        productData.productPrice = product.productPrice
        productData.productDescription = product.productDescription
        productData.productTitle = product.productTitle
        
        do {
            try productData.managedObjectContext?.save()
        } catch {
            print("Error saving product data: \(error)")
        }
    }
    
    private func loadPersistentStore() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to load persistent store: \(error)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    print("Error fetching data: \(error)")
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension OrdersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.frame = CGRect(x: 15, y: 5, width: tableView.frame.width - 10, height: 40)
        headerLabel.text = "Shopping Cart 🛒"
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 25, weight: .bold)
        headerLabel.textColor = .black
        return headerLabel
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
}

// MARK: - UITableViewDataSource

extension OrdersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?.first?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productData = fetchedResultsController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OrderCell
        cell.configure(productData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let productData = fetchedResultsController.object(at: indexPath)
            persistentContainer.viewContext.delete(productData)
            try? persistentContainer.viewContext.save()
        }
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension OrdersViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ordersTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        ordersTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                ordersTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                print("Product at indexPath \(indexPath) updated")
            }
        case .move:
            if let indexPath = indexPath {
                ordersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                ordersTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                ordersTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError("Unexpected case in NSFetchedResultsControllerDelegate")
        }
    }
}
