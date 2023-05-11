//
//  Client.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

struct ClientModel: Codable {
    let id: String?
    let name: String?
    let surname: String?
    let ci: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case surname = "apellido"
        case ci = "cedula"
    }
}
