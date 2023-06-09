//
//  ProductModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import Foundation

struct ProductModel: Codable {
    let id: Int?
    let name: String?
    let sellingPrice: String?
    let category: CategoryModel?
    
    var description: String {
        if let name = name {
            return name
        }
        
        return "Select Product"
    }
    
    init() {
        self.id = nil
        self.name = nil
        self.sellingPrice = nil
        self.category = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case sellingPrice = "precio_venta"
        case category = "Category"
    }
}
