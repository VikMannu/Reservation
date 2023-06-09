//
//  TableModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

struct TableModel: Codable {
    let id: Int?
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
    
    init() {
        self.id = 4
        self.name = ""
        self.positionX = 1
        self.positionY = 1
        self.floor = 1
        self.diners = 1
        self.restaurantId = "1"
    }
    
    init(id: Int?, name: String?, positionX: Int?, positionY: Int?, floor: Int?, diners: Int?, restaurantId: String?) {
        self.id = id
        self.name = name
        self.positionX = positionX
        self.positionY = positionY
        self.floor = floor
        self.diners = diners
        self.restaurantId = restaurantId
    }
    
}
