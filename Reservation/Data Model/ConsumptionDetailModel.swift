//
//  ConsumptionDetailModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import Foundation

struct ConsumptionDetailModel: Codable {
    let id: Int?
    let quantity: Int?
    let consumptionHeaderId: Int?
    let product: ProductModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case quantity = "cantidad"
        case consumptionHeaderId = "ConsumoHeaderId"
        case product = "Producto"
    }
    
    init() {
        self.id = nil
        self.quantity = nil
        self.consumptionHeaderId = nil
        self.product = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.consumptionHeaderId = try container.decode(Int.self, forKey: .consumptionHeaderId)
        self.product = try container.decode(ProductModel.self, forKey: .product)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.quantity, forKey: .quantity)
        try container.encode(self.consumptionHeaderId, forKey: .consumptionHeaderId)
        try container.encode(self.product, forKey: .product)
    }
}
