//
//  TablesViewModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import SwiftUI

class TablesViewModel: ObservableObject {
    @Published var isLoading = false
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
}
