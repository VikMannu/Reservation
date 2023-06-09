//
//  CategoryModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import Foundation

struct CategoryModel: Codable {
    let id: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
    }
}
