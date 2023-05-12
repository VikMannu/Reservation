//
//  FilterViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

class ReservationsViewModel: ObservableObject {
    @Published var isLoading = false
    
    private let restaurant: RestaurantModel
    
    var selectedClient: ClientModel?
    
    var reservations = [ReservationModel]()
    
    @Published var selectedClientTitle: String = ""
    @Published var selectedDate = Date()
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
    }
    
    func getReservations() {
        self.isLoading = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd zzz"
        dateFormatter.timeZone = TimeZone.current
        
        var parameters: [String: Any] = [
            "RestauranteId": restaurant.id ?? "",
            "fecha": dateFormatter.string(from: selectedDate)
        ]
        
        if let idClient = self.selectedClient?.id {
            parameters["ClienteId"] = idClient
        }
        
        APIClient.apiRequest(
            method: .get,
            api: .reservation("rest-cliente-fecha"),
            parameters: parameters,
            successHandler: { (reservations: [ReservationModel]) in
                self.reservations = reservations
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
