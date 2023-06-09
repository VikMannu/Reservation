//
//  Client.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

struct ClientModel: Codable {
    let id: Int?
    let name: String?
    let surname: String?
    let ci: String?
    
    var description: String {
        return "\(ci ?? "") | \(name ?? "") \(surname ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name = "nombre"
        case surname = "apellido"
        case ci = "cedula"
    }
    
    init() {
        self.id = nil
        self.name = nil
        self.surname = nil
        self.ci = nil
    }
    
    init(id: Int, name: String, surname: String, ci: String) {
        self.id = id
        self.name = name
        self.surname = surname
        self.ci = ci
    }
    
    init(name: String, surname: String, ci: String) {
        self.id = nil
        self.name = name
        self.surname = surname
        self.ci = ci
    }
}
