//
//  ResponseReservationModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import Foundation

struct ResponseReservationModel: Codable {
    let restaurantId: Int
    let tableId: Int
    let clientId: Int
    let date: Date
    let startTime: Int
    let endTime: Int
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case restaurantId = "RestauranteId"
        case tableId = "MesaId"
        case clientId = "ClienteId"
        case dateISO8601 = "fecha"
        case startTime = "horaInicio"
        case endTime = "horaFin"
        case quantity = "cantidad"
    }
    
    init(restaurantId: Int, tableId: Int, clientId: Int, date: Date, startTime: Int, endTime: Int, quantity: Int) {
        self.restaurantId = restaurantId
        self.tableId = tableId
        self.clientId = clientId
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.quantity = quantity
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try container.decode(Int.self, forKey: .restaurantId)
        tableId = try container.decode(Int.self, forKey: .tableId)
        clientId = try container.decode(Int.self, forKey: .clientId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        date = try dateFormatter.date(from: container.decode(String.self, forKey: .dateISO8601)) ?? Date()
        startTime = try container.decode(Int.self, forKey: .startTime)
        endTime = try container.decode(Int.self, forKey: .endTime)
        quantity = try container.decode(Int.self, forKey: .quantity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(restaurantId, forKey: .restaurantId)
        try container.encode(tableId, forKey: .tableId)
        try container.encode(clientId, forKey: .clientId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        try container.encode(dateFormatter.string(from: date), forKey: .dateISO8601)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(quantity, forKey: .quantity)
    }
}
