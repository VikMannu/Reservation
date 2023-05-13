//
//  ConfirmationTable.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI

struct ConfirmationTableView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ConfirmationTableViewModel
    
    init(availableSchedule: RequestAvailableSchedulesModel, selectedTable: TableModel, selectedClient: ClientModel) {
        self._viewModel = StateObject(wrappedValue: ConfirmationTableViewModel(availableSchedule: availableSchedule, selectedTable: selectedTable, selectedClient: selectedClient))
    }
    
    var body: some View {
        VStack {
            Text("Restaurant")
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
                .font(.system(size: 20))
            Text(viewModel.restaurant.name ?? "")
            Divider()
            RowTable(table: viewModel.selectedTable)
            Divider()
            VStack {
                Text("Client")
                    .foregroundColor(Color.blue)
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                Text("\(viewModel.selectedClient.name ?? "") - \(viewModel.selectedClient.surname ?? "")")
            }
            Divider()
            Text("Schedules")
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
                .font(.system(size: 20))
            List(viewModel.availableSchedule.schedules, id: \.id) { shedules in
                Text("\(shedules.startTime):00 - \(shedules.endTime):00")
            }.listStyle(.plain)
            Button("Confirm", action: { self.confirmReservation() })
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 36)
                .background(Color.blue)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                )
                .padding(.all).padding(.bottom, 20)
        }
        .navigationTitle("Confirm Reservation")
        .overlay(
            ZStack {
                if viewModel.isLoading {
                    Color.gray.opacity(0.7)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        )
    }
    
    private func confirmReservation() {
        self.viewModel.confirmReservation()
    }
}

struct ConfirmationTableView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmationTableView(availableSchedule: RequestAvailableSchedulesModel(), selectedTable: TableModel(id: "1", name: "Test", positionX: 1, positionY: 1, floor: 2, diners: 12, restaurantId: "1"), selectedClient: ClientModel(id: "1", name: "Juan", surname: "Perez", ci: "12345"))
    }
}
