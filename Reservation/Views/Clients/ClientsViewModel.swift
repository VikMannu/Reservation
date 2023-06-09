//
//  ClientsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

enum StatusOpenTable {
    case success
    case failed
}

class ClienstViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var clients = [ClientModel]()
    let selectedTable: TableModel?
    
    init(table: TableModel? = nil) {
        self.selectedTable = table
    }
    
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
    
    func openTable(client: ClientModel, completation: @escaping (StatusOpenTable) -> ()) {
        let params: JSONObject = [
            "idMesa": selectedTable?.id ?? 0,
            "idCliente": client.id ?? 0
        ]
        
        self.isLoading = true
        APIClient.apiRequest(
            method: .post,
            api: .services("abrir-mesa"),
            parameters: params,
            successHandler: { (consumptionHeaderModel: ConsumptionHeaderModel) in
                completation(.success)
                self.isLoading = true
            },
            errorHandler: { (error: ErrorModel) in
                completation(.failed)
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
