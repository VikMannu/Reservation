//
//  ProductsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-09.
//

import SwiftUI

class ProductsViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var products = [ProductModel]()
    
    func getProducts() {
        self.isLoading = true
        APIClient.apiRequest(
            api: .product(""),
            successHandler: { (products: [ProductModel]) in
                self.products = products
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
