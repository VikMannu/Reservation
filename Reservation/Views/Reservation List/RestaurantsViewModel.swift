//
//  RestaurantsViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class RestaurantsViewModel: ObservableObject {
    @Published var restaurants = [RestaurantModel]()
    
    init() {
        self.getRestaurants()
    }
    
    private func getRestaurants() {
        APIClient.apiRequest(
            method: .get,
            api: .restaurant(""),
            encoding: .default,
            successHandler: { (restaurants: [RestaurantModel]) in
                self.restaurants = restaurants
            },
            errorHandler: { (error: ErrorModel) in
                return false // Unknown error, use default error handler.
            }
        )
    }
}

