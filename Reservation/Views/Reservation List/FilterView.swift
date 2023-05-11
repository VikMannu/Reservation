//
//  FilterView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct FilterView: View {
    @StateObject var viewModel: FilterViewModel
    
    private let currentDate = Date()
    
    init(restaurant: RestaurantModel) {
        self._viewModel = StateObject(wrappedValue: FilterViewModel(restaurant: restaurant))
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
            Divider()
                .foregroundColor(Color.blue)
            Spacer()
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
    } // Body
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(restaurant: RestaurantModel(id: "1", name: "Lido Bar", address: "Asunción"))
    }
}
