//
//  ConfirmationTable.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI

struct ConfirmationTableView: View {
    @StateObject var viewModel: ConfirmationTableViewModel
    
    init(availableSchedule: RequestAvailableSchedulesModel, selectedTable: TableModel, selectedClient: ClientModel) {
        self._viewModel = StateObject(wrappedValue: ConfirmationTableViewModel(availableSchedule: availableSchedule, selectedTable: selectedTable, selectedClient: selectedClient))
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ConfirmationTableView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationTableView(availableSchedule: RequestAvailableSchedulesModel(), selectedTable: TableModel(id: "1", name: "Test", positionX: 1, positionY: 1, floor: 2, diners: 12, restaurantId: "1"), selectedClient: ClientModel(id: "1", name: "Juan", surname: "Perez", ci: "12345"))
    }
}
