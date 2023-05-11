//
//  FilterViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class FilterViewModel: ObservableObject {
    private let restaurant: RestaurantModel
    
    var selectedClient: ClientModel?
    
    @Published var selectedClientTitle: String = ""
    @Published var selectedDate = Date()
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
    }
    
    func getReservations() {
        
    }
}
