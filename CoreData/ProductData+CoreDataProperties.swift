//
//  ProductData+CoreDataProperties.swift
//  Marketplace
//
//  Created by Алексей Кобяков on 22.10.2022.
//
//

import Foundation
import CoreData


extension ProductData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductData> {
        return NSFetchRequest<ProductData>(entityName: "ProductData")
    }

    @NSManaged public var productImage: Data?
    @NSManaged public var productTitle: String?
    @NSManaged public var productPrice: String?
    @NSManaged public var productDescription: String?

}

extension ProductData : Identifiable {

}
