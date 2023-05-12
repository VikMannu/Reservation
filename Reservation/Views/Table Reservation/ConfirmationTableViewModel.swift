//
//  ConfirmationTabbleViewModel.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI

class ConfirmationTableViewModel: ObservableObject {
    let availableSchedule: RequestAvailableSchedulesModel
    let selectedTable: TableModel
    let selectedClient: ClientModel
    private let responseReservations: [ResponseReservationModel]
    
    init(availableSchedule: RequestAvailableSchedulesModel, selectedTable: TableModel, selectedClient: ClientModel) {
        self.availableSchedule = availableSchedule
        self.selectedTable = selectedTable
        self.selectedClient = selectedClient
        self.responseReservations = [ResponseReservationModel]()
    }
    
    private func getResponseReservations() -> [ResponseReservationModel] {
        var responseReservations = [ResponseReservationModel]()
        self.availableSchedule.schedules.forEach { schedule in
            responseReservations.append(ResponseReservationModel(restaurantId: availableSchedule.restaurantId, tableId: selectedTable.id ?? "", clientId: selectedClient.id ?? "", date: availableSchedule.date, startTime: schedule.startTime, endTime: schedule.endTime, quantity: selectedTable.diners ?? 1))
        }
        return responseReservations
    }
}
