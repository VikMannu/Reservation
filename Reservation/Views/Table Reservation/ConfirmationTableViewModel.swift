//
//  ConfirmationTabbleViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI

class ConfirmationTableViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var restaurant: RestaurantModel = RestaurantModel(id: "", name: "", address: "")
    let availableSchedule: RequestAvailableSchedulesModel
    let selectedTable: TableModel
    let selectedClient: ClientModel
    private var responseReservations: [ResponseReservationModel] {
        var responseReservations = [ResponseReservationModel]()
        self.availableSchedule.schedules.forEach { schedule in
            responseReservations.append(ResponseReservationModel(restaurantId: availableSchedule.restaurantId, tableId: selectedTable.id ?? "", clientId: selectedClient.id ?? "", date: availableSchedule.date, startTime: schedule.startTime, endTime: schedule.endTime, quantity: selectedTable.diners ?? 1))
        }
        return responseReservations
    }
    
    init(availableSchedule: RequestAvailableSchedulesModel, selectedTable: TableModel, selectedClient: ClientModel) {
        self.availableSchedule = availableSchedule
        self.selectedTable = selectedTable
        self.selectedClient = selectedClient
        self.getRestaurant()
    }
    
    private func getRestaurant() {
        self.isLoading = true
        APIClient.apiRequest(
            method: .get,
            api: .restaurant(availableSchedule.restaurantId),
            successHandler: { (restaurant: RestaurantModel) in
                self.restaurant = restaurant
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
    
    func confirmReservation() {
        self.isLoading = true
        let dispatch = DispatchGroup()
        
        self.responseReservations.forEach { response in
            dispatch.enter()
            APIClient.apiRequest(
                method: .post,
                api: .reservation(""),
                parameters: response.dictionary ?? ["":""],
                encoding: .json,
                successHandler: { (reservation: ReservationModel) in
                    Utils.showBarnner(title: "Reservation added successfully", subtitle: "Added the reservation for \(reservation.quantity ?? 0) people in the name of \(reservation.client?.name ?? "")")
                    dispatch.leave()
                },
                errorHandler: { (error: ErrorModel) in
                    dispatch.leave()
                    return false // Unknown error, use default error handler.
                }
            )
            
        }
        
        dispatch.notify(queue: .main, execute: {
            self.isLoading = false
        })
    }
}
