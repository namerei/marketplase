//
//  CartViewController.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 29.09.2022.
//

import UIKit
import CoreData

class CartViewController: UIViewController {
    private let persistentContainer = NSPersistentContainer(name: "Model")
    let cellID: String = "CartProductCell"
    var productsInCart: [Product] = []
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .systemGray4
        tableView.rowHeight = view.frame.height/6
        return tableView
    }()
    
    private lazy var fetchedResultController: NSFetchedResultsController<ProductData> = {
        let fetchRequest = ProductData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "productTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        return fetchResultController
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        tableView.register(CartProductCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupContstraints()
        //print("cart open")
        loadContainer()
    }
    
    private func setupContstraints() {
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func updateTableViewElements(product: Product) {
        self.productsInCart.append(product)
        print(productsInCart.count)
        //saveCart()
        print("Add to cart item")
        let productData = ProductData.init(entity: NSEntityDescription.entity(forEntityName: "ProductData", in: persistentContainer.viewContext)!, insertInto: persistentContainer.viewContext)
        productData.productImage = product.productImage.pngData()
        productData.productPrice = product.productPrice
        productData.productDescription = product.productDescription
        productData.productTitle = product.productTitle
        try? productData.managedObjectContext?.save()
    }
    
    private func loadContainer() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("Unable to load persistent store")
                print("\(error)")
            } else {
                do {
                    try self.fetchedResultController.performFetch()
                } catch {
                    print(error)
                }
            }
        }
        print("FetchedObj \(fetchedResultController.sections?[0].numberOfObjects ?? 99)")
    }
}
// MARK: - extenstions
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.frame = CGRect.init(x: 15, y: 5, width: tableView.frame.width-10, height: tableView.frame.height-10)
                label.text = "Cart"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        45
    }
}

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let productData = fetchedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? CartProductCell
        cell?.configure(productData)
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            let productData = fetchedResultController.object(at: indexPath)
            persistentContainer.viewContext.delete(productData)
            try? persistentContainer.viewContext.save()
        }
    }
}

extension CartViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                print(indexPath)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        @unknown default:
            fatalError()
        }
    }
}
