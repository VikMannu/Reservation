//
//  ReservationModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

struct ReservationModel: Codable {
    let id: String?
    let date: Date?
    let timeRange: [TimeRange]?
    let quantity: Int?
    let restaurant: RestaurantModel?
    let client: ClientModel?
    let table: TableModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateISO8601 = "fecha"
        case timeRange = "rangoHora"
        case quantity = "cantidad"
        case restaurant = "Restaurante"
        case client = "Cliente"
        case table = "Mesa"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        let formatter = ISO8601DateFormatter()
        date = try formatter.date(from: container.decode(String.self, forKey: .dateISO8601))
        timeRange = try container.decode([TimeRange].self, forKey: .timeRange)
        quantity = try container.decode(Int.self, forKey: .quantity)
        restaurant = try container.decode(RestaurantModel.self, forKey: .restaurant)
        client = try container.decode(ClientModel.self, forKey: .client)
        table = try container.decode(TableModel.self, forKey: .table)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        let formatter = ISO8601DateFormatter()
        try container.encode(formatter.string(from: date ?? Date()), forKey: .dateISO8601)
        try container.encode(timeRange, forKey: .timeRange)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(restaurant, forKey: .restaurant)
        try container.encode(client, forKey: .client)
        try container.encode(table, forKey: .table)
    }
}

struct TimeRange: Codable {
    let value: Date?
    let include: Bool?
    
    enum CodingKeys: String, CodingKey {
        case dateISO8601 = "value"
        case include = "inclusive"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let stringDate = try container.decode(String.self, forKey: .dateISO8601)
        value = formatter.date(from: stringDate)
        include = try container.decode(Bool.self, forKey: .include)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let formatter = ISO8601DateFormatter()
        try container.encode(formatter.string(from: value ?? Date()), forKey: .dateISO8601)
        try container.encode(include, forKey: .include)
    }
}
