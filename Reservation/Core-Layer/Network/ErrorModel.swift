//
//  ErrorModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-08.
//

import Foundation

struct ErrorModel: Codable {
    static let genericMessage = "Disculpe los inconvenientes"
    static let reportMessage = "Error al obtener reporte"
    static let extractMessage = "Error al obtener extracto"
    static let networkMessage = "No se pudo establecer contacto con el servicio. Verifique su conexión a la red."
    
    var message: String?
    init (message: String) {
        self.message = message
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    func getMessage() -> String {
        return message ?? ErrorModel.genericMessage
    }
}
