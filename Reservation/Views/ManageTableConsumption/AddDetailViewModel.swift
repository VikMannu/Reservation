//
//  AddDetailViewModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-09.
//

import SwiftUI

enum StatusAddDetail {
    case success
    case failed
}

class AddDetailViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var selectedProduct = ProductModel()
    
    let table: TableModel
    
    init(table: TableModel) {
        self.table = table
    }
    
    func addDetail(quantity: Int, completation: @escaping (StatusAddDetail) -> ()) {
        let params: JSONObject = [
            "idMesa": table.id ?? "",
            "idProducto": selectedProduct.id ?? "",
            "cantidad": quantity
        ]
        self.isLoading = true
        APIClient.apiRequest(
            method: .post,
            api: .consumptionDetails(""),
            parameters: params,
            successHandler: { (message: MessageModel) in
                Utils.showBarnner(title: "Success", subtitle: message.message ?? "Product successfully added")
                completation(.success)
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                completation(.failed)
                return false // Unknown error, use default error handler.
            }
        )
    }
}
