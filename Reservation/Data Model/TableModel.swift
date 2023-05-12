//
//  TableModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

struct TableModel: Codable {
    let id: String?
    let name: String?
    let positionX: Int?
    let positionY: Int?
    let floor: Int?
    let diners: Int?
    let restaurantId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case positionX = "posicionX"
        case positionY = "posicionY"
        case floor = "planta"
        case diners = "comensales"
        case restaurantId = "RestauranteId"
    }
}
