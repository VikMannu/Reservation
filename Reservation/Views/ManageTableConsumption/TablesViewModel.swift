//
//  TablesViewModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import SwiftUI

enum StatusOpenTable {
    case success
    case failed
}

class TablesViewModel: ObservableObject {
    @Published var isLoading = false
    var selectedTable: TableModel = TableModel()
    var tables = [TableModel]()
    
    func getTables() {
        self.isLoading = true
        APIClient.apiRequest(
            api: .table(""),
            successHandler: { (tables: [TableModel]) in
                self.tables = tables
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
    
    func getStatusTable(completetion: @escaping (StatusTable) -> ()) {
        self.isLoading = true
        APIClient.apiRequest(
            api: .services("verificar-estado/\(selectedTable.id ?? 0)"),
            successHandler: { (statusTable: StatusTableModel) in
                completetion(statusTable.message ?? .unspecified)
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                completetion(.unspecified)
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
    
    func openTable(client: ClientModel, completation: @escaping (StatusOpenTable) -> ()) {
        let params: JSONObject = [
            "idMesa": selectedTable.id ?? 0,
            "idCliente": client.id ?? 0
        ]
        
        self.isLoading = true
        APIClient.apiRequest(
            method: .post,
            api: .services("abrir-mesa"),
            parameters: params,
            successHandler: { (consumptionHeaderModel: ConsumptionHeaderModel) in
                completation(.success)
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                completation(.failed)
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
