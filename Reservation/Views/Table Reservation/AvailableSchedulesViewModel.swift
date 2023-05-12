//
//  HoursAvailableView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI
import Alamofire

class AvailableSchedulesViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var tables = [TableModel]()
    @Published var selectedClientTitle: String = ""
    
    let availableSchedule: RequestAvailableSchedulesModel
    var selectedClient: ClientModel?
    
    init(availableSchedule: RequestAvailableSchedulesModel) {
        self.availableSchedule = availableSchedule
        self.getAvailableSchedule()
    }
    
    private func getAvailableSchedule() {
        self.isLoading = true
        APIClient.apiRequest(
            method: .put,
            api: .services("disponibles"),
            parameters: availableSchedule.dictionary ?? ["":""],
            encoding: .json,
            successHandler: { (tables: [TableModel]) in
                self.tables = tables
                self.isLoading = false
            },
            errorHandler: { (error: ErrorModel) in
                self.isLoading = false
                return false // Unknown error, use default error handler.
            }
        )
    }
}
