//
//  Discovery.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

struct Discovery {
    static var shared = Discovery()
    var services: [ServiceAPIModel]?
    
    init() {
        let service1 = ServiceAPIModel(service: "reserva", location: "http://localhost:9090/api")
        let service2 = ServiceAPIModel(service: "restaurante", location: "http://localhost:9090/api")
        let service3 = ServiceAPIModel(service: "cliente", location: "http://localhost:9090/api")
        let service4 = ServiceAPIModel(service: "services", location: "http://localhost:9090/api")
        let service5 = ServiceAPIModel(service: "mesa", location: "http://localhost:9090/api")
        let service6 = ServiceAPIModel(service: "consumoHeader", location: "http://localhost:9090/api")
        let service7 = ServiceAPIModel(service: "detalles", location: "http://localhost:9090/api")
        let service8 = ServiceAPIModel(service: "producto", location: "http://localhost:9090/api")
        self.services = []
        self.services?.append(service1)
        self.services?.append(service2)
        self.services?.append(service3)
        self.services?.append(service4)
        self.services?.append(service5)
        self.services?.append(service6)
        self.services?.append(service7)
        self.services?.append(service8)
    }
}

struct ServiceAPIModel: Codable {
    let service: String?
    let location: String?
    
    init(service: String, location: String) {
        self.service = service
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case service, location
    }
}

enum DiscoveryAPI {
    case reservation(String)
    case restaurant(String)
    case client(String)
    case services(String)
    case table(String)
    case consumptionHeader(String)
    case consumptionDetails(String)
    case product(String)

    /// The API identifier used by the discovery service.
    var urlString: String? {
        var serv = ""
        var command = ""
        switch self {
        case .reservation(let cmd):
            serv = "reserva"
            command = cmd
        case .restaurant(let cmd):
            serv = "restaurante"
            command = cmd
        case .client(let cmd):
            serv = "cliente"
            command = cmd
        case .services(let cmd):
            serv = "services"
            command = cmd
        case .table(let cmd):
            serv = "mesa"
            command = cmd
        case .consumptionHeader(let cmd):
            serv = "consumoHeader"
            command = cmd
        case .consumptionDetails(let cmd):
            serv = "detalles"
            command = cmd
        case .product(let cmd):
            serv = "producto"
            command = cmd
        }
        
        if let location = locationFor(service: serv) {
            let value = location.replacingOccurrences(of: "\n", with: "") + "/" + command
            return value.trimmed()
        }
        return nil
    }
    
    /// The base URL of the API.
    func locationFor(service: String) -> String? {
        let location = Discovery.shared.services?.filter({ serviceIn in
            serviceIn.service == service
        })
        return "\(location?.first?.location ?? "")/\(service)"
    }
}

