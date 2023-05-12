//
//  FilterView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct ReservationsView: View {
    @StateObject var viewModel: ReservationsViewModel
    
    private let currentDate = Date()
    
    init(restaurant: RestaurantModel) {
        self._viewModel = StateObject(wrappedValue: ReservationsViewModel(restaurant: restaurant))
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
                in: ...currentDate,
                displayedComponents: [.date]
            )
            .padding(.horizontal)
            .onChange(of: viewModel.selectedDate) { newDate in
                viewModel.getReservations()
            }
            
            Divider()
                .foregroundColor(Color.blue)
            List(viewModel.reservations, id: \.id) { reservation in
                Text(reservation.table?.name ?? "")
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
