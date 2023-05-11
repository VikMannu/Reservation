//
//  ClientsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class ClienstViewModel: ObservableObject {
    @Published var clients = [ClientModel]()
    
    init() {
        self.getClients()
    }
    
    private func getClients() {
        APIClient.apiRequest(
            method: .get,
            api: .client(""),
            encoding: .default,
            successHandler: { (clients: [ClientModel]) in
                self.clients = clients
            },
            errorHandler: { (error: ErrorModel) in
                return false // Unknown error, use default error handler.
            }
        )
    }
}
