//
//  RequestAvailableHoursModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import Foundation

struct RequestAvailableHoursModel: Codable {
    let restaurantId: String
    let date: Date
    let hours: [Time]
    
    enum CodingKeys: String, CodingKey {
        case restaurantId = "RestauranteId"
        case date = "fecha"
        case hours = "listaHoras"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try container.decode(String.self, forKey: .restaurantId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        date = try dateFormatter.date(from: container.decode(String.self, forKey: .date)) ?? Date()
        hours = try container.decode([Time].self, forKey: .hours)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(restaurantId, forKey: .restaurantId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        try container.encode(dateFormatter.string(from: date), forKey: .date)
        try container.encode(date, forKey: .date)
        try container.encode(hours, forKey: .hours)
    }
}

struct Time: Codable, Identifiable {
    let id = UUID()
    let startTime: Int
    let endTime: Int
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case startTime = "horaInicio"
        case endTime = "horaFin"
    }
}
