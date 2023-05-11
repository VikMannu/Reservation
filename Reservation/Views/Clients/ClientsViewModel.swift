//
//  ClientsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class ClienstViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var clients = [ClientModel]()
    
    func getClients() {
        self.isLoading = true
        APIClient.apiRequest(
            method: .get,
            api: .client(""),
            encoding: .default,
            successHandler: { (clients: [ClientModel]) in
                self.clients = clients
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
