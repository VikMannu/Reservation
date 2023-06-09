//
//  ConsumptionHeaderModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import Foundation

struct ConsumptionHeaderModel: Codable {
    let id: Int?
    let status: StatusConsumptionHeader?
    let total: Int?
    let table: TableModel?
    let client: ClientModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status = "estado"
        case total
        case table = "Mesa"
        case client = "Cliente"
    }
    
    init() {
        self.id = nil
        self.status = nil
        self.total = nil
        self.table = nil
        self.client = nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.status = try container.decode(StatusConsumptionHeader.self, forKey: .status)
        self.total = try container.decode(Int.self, forKey: .total)
        self.table = try container.decode(TableModel.self, forKey: .table)
        self.client = try container.decode(ClientModel.self, forKey: .client)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.status, forKey: .status)
        try container.encode(self.total, forKey: .total)
        try container.encode(self.table, forKey: .table)
        try container.encode(self.client, forKey: .client)
    }
}

enum StatusConsumptionHeader: String, Codable {
    case `open` = "abierto"
    case `closed` = "cerrado"
    
    var description: String {
        return self.rawValue
    }
}
