//
//  RestaurantsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class RestaurantsViewModel: ObservableObject {
    @Published var isLoading = false
    
    @Published var restaurants = [RestaurantModel]()
    
    init() {
        self.getRestaurants()
    }
    
    private func getRestaurants() {
        self.isLoading = true
        APIClient.apiRequest(
            method: .get,
            api: .restaurant(""),
            encoding: .default,
            successHandler: { (restaurants: [RestaurantModel]) in
                self.restaurants = restaurants
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}

