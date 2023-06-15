//
//  HoursAvailableView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-12.
//

import SwiftUI

struct AvailableSchedulesView: View {
    @StateObject var viewModel: AvailableSchedulesViewModel
    
    init(availableSchedule: RequestAvailableSchedulesModel) {
        self._viewModel = StateObject(wrappedValue: AvailableSchedulesViewModel(availableSchedule: availableSchedule))
    }
    
    var body: some View {
        VStack {
            Divider()
                .foregroundColor(Color.blue)
            ZStack(alignment: .center, content: {
                NavigationLink(
                    destination: { ClientsView(delegate: self) },
                    label: {
                        HStack {
                            TextField("Select Client", text: $viewModel.selectedClientTitle)
                                .padding(.horizontal)
                            
                            Image(systemName: "arrow.right")
                                .padding(.horizontal)
                                .foregroundColor(Color.gray)
                        }
                    }
                )
            })
            .foregroundColor(.gray)
            .frame(height: 40)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray)
            }
            .padding(.horizontal)
            Divider()
            List(viewModel.tables, id: \.id) { table in
                if let selectedClient = viewModel.selectedClient {
                    NavigationLink(
                        destination: { ConfirmationTableView(availableSchedule: viewModel.availableSchedule, selectedTable: table, selectedClient: selectedClient) },
                        label: { RowTable(table: table) }
                    )
                } else {
                    RowTable(table: table)
                }
            }
        }
        .navigationTitle("Available Schedules")
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
}

extension AvailableSchedulesView: ClientsViewDelegate {
    func selectedClient(client: ClientModel) {
        self.viewModel.selectedClient = client
        self.viewModel.selectedClientTitle = client.description
    }
    
    
}

struct AvailableSchedulesView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableSchedulesView(availableSchedule: RequestAvailableSchedulesModel())
    }
}


struct RowTable: View {
    let table: TableModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text(table.name ?? "")
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
                .font(.system(size: 20))
            Divider()
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("PositionX: \(table.positionX ?? 0)")
                    Text("Floor: \(table.floor ?? 0)")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("PositionY: \(table.positionY ?? 0)")
                    Text("Diners: \(table.diners ?? 0)")
                }
            }.padding(.horizontal)
        }.padding(.horizontal)
    }
}

struct RowTableMin: View {
    let table: TableModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text(table.name ?? "")
                .foregroundColor(Color.blue)
                .fontWeight(.bold)
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("PositionX: \(table.positionX ?? 0)")
                    Text("Floor: \(table.floor ?? 0)")
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text("PositionY: \(table.positionY ?? 0)")
                    Text("Diners: \(table.diners ?? 0)")
                }
            }.padding(.horizontal)
        }.padding(.horizontal)
    }
}
