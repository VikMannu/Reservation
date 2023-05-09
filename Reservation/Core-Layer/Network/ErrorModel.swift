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
    
    var code: String?
    var message: String?
    var type: String?
    var useApiMessage: Bool?
    
    init (useApiMessage: Bool, message: String, code: String) {
        self.useApiMessage = useApiMessage
        self.message = message
        self.code = code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decodeIfPresent(String.self, forKey: .code)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.useApiMessage = try container.decodeIfPresent(Bool.self, forKey: .useApiMessage)
    }
    
    func getMessage() -> String {
        return (useApiMessage ?? false) ? message ?? ErrorModel.genericMessage : ErrorModel.genericMessage
    }
}
