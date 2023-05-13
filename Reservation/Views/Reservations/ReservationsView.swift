//
//  FilterView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct ReservationsView: View {
    @StateObject var viewModel: ReservationsViewModel
    
    let formatter = DateFormatter()
    
    private let currentDate = Date()
    private let minDate: Date
    private let maxDate: Date

    
    init(restaurant: RestaurantModel) {
        self._viewModel = StateObject(wrappedValue: ReservationsViewModel(restaurant: restaurant))
        formatter.timeStyle = .short
        minDate = Calendar.current.date(byAdding: .year, value: -123, to: currentDate)!
        maxDate = Calendar.current.date(byAdding: .year, value: 177, to: currentDate)!
    }
    
    var body: some View {
        VStack {
            Divider()
                .foregroundColor(Color.blue)
            ZStack(alignment: .center, content: {
                NavigationLink(
                    destination: { ClientsView(viewModelFilter: viewModel) },
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
                .foregroundColor(Color.blue)
            DatePicker(
                "Select date:",
                selection: $viewModel.selectedDate,
                in: minDate...maxDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal)
            .onChange(of: viewModel.selectedDate) { newDate in
                viewModel.getReservations()
            }
            
            Divider()
                .foregroundColor(Color.blue)
            List(viewModel.reservations, id: \.id) { reservation in
                VStack {
                    Text(viewModel.restaurant.name ?? "")
                        .foregroundColor(Color.blue)
                        .fontWeight(.bold)
                    RowTableMin(table: reservation.table ?? TableModel())
                    VStack {
                        Text("Client")
                            .foregroundColor(Color.blue)
                            .fontWeight(.bold)
                        Text("\(reservation.client?.name ?? "") \(reservation.client?.surname ?? "")")
                    }
                    Text("Schedule")
                        .foregroundColor(Color.blue)
                        .fontWeight(.bold)
                    HStack(spacing: 10) {
                        Text(formatter.string(from: reservation.timeRange?[0].value ?? Date()))
                        Text(formatter.string(from: reservation.timeRange?[1].value ?? Date()))
                    }
                }
            }
        } // Main VStack
        .navigationTitle("Reservations")
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
        .onAppear {
            viewModel.getReservations()
        }
    } // Body
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationsView(restaurant: RestaurantModel(id: "1", name: "Lido Bar", address: "Asunción"))
    }
}
