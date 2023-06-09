//
//  RequestAvailableHoursModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import Foundation

struct RequestAvailableSchedulesModel: Codable {
    let restaurantId: Int
    let date: Date
    let schedules: [Schedule]
    
    enum CodingKeys: String, CodingKey {
        case restaurantId = "RestauranteId"
        case dateISO8601 = "fecha"
        case schedules = "listaHoras"
    }
    
    init() {
        self.restaurantId = 1
        self.date = Date()
        self.schedules = [Schedule(startTime: 14, endTime: 15), Schedule(startTime: 15, endTime: 16)]
    }
    
    init(restaurantId: Int, date: Date, schedules: [Schedule]) {
        self.restaurantId = restaurantId
        self.date = date
        self.schedules = schedules
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        restaurantId = try container.decode(Int.self, forKey: .restaurantId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        date = try dateFormatter.date(from: container.decode(String.self, forKey: .dateISO8601)) ?? Date()
        schedules = try container.decode([Schedule].self, forKey: .schedules)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(restaurantId, forKey: .restaurantId)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        try container.encode(dateFormatter.string(from: date), forKey: .dateISO8601)
        try container.encode(schedules, forKey: .schedules)
    }
}

struct Schedule: Codable, Identifiable {
    let id = UUID()
    let startTime: Int
    let endTime: Int
    var isSelected = false
    
    enum CodingKeys: String, CodingKey {
        case startTime = "horaInicio"
        case endTime = "horaFin"
    }
}
