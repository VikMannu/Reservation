//
//  ContentViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    init() {
        APIClient.apiRequest(
            method: .get,
            api: .restaurant(""),
            encoding: .default,
            successHandler: { (restaurants: [RestaurantModel]) in
                print(restaurants)
            },
            errorHandler: { (error: ErrorModel) in
                if error.code == "a123" {
                    print("Test")
                    return true // Error was handled correctly.
                }
                return false // Unknown error, use default error handler.
            }
        )
    }
}
