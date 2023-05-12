//
//  HoursAvailableViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import Foundation

class ReservationDateSelectorViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var selectedDate = Date()
    
    let restaurant: RestaurantModel
    @Published var schedules = [Schedule]()
    
    init(restaurant: RestaurantModel) {
        self.restaurant = restaurant
        self.schedules = loadSchedules()
    }
    
    private func loadSchedules() -> [Schedule] {
        var schedules = [Schedule]()
        
        for index in 12...22 {
            schedules.append(Schedule(startTime: index, endTime: index+1))
        }
        
        return schedules
    }
    
    func isAtLeastOneItemSelected() -> Bool {
        if let _ = schedules.first(where: { $0.isSelected }) {
            return true
        }
        return false
    }
    
    func getSelectedSchedules() -> [Schedule] {
        return self.schedules.filter({ $0.isSelected })
    }
}
