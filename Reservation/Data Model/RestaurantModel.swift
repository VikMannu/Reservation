//
//  Restaurant.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

struct RestaurantModel: Codable {
    let id: String?
    let name: String?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case address = "direccion"
    }
}
