//
//  HoursAvailableViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

class ReservationDateSelectorViewModel: ObservableObject {
    @Published var selectedDate = Date()
    
    private let restaurant: RestaurantModel
    @Published var hours = [Time]()
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        self.hours = loadHours()
    }
    
    private func loadHours() -> [Time] {
        var hours = [Time]()
        
        for index in 12...22 {
            hours.append(Time(startTime: index, endTime: index+1))
        }
        
        return hours
    }
    
    func isAtLeastOneItemSelected() -> Bool {
        if let _ = hours.first(where: { $0.isSelected }) {
            return true
        }
        return false
    }
}
