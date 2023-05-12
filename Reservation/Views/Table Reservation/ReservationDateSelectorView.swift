//
//  HoursAvailableView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import SwiftUI

struct ReservationDateSelectorView: View {
    @StateObject var viewModel: ReservationDateSelectorViewModel
    
    @State private var isEditing = false
    @State var nextView: Bool = false
    
    private let currentDate = Date()
    
    init(restaurant: RestaurantModel) {
        self._viewModel = StateObject(wrappedValue: ReservationDateSelectorViewModel(restaurant: restaurant))
    }
    
    var body: some View {
        VStack {
            DatePicker(
                "Select date:",
                selection: $viewModel.selectedDate,
                in: currentDate...,
                displayedComponents: [.date]
            )
            List(Array(viewModel.hours.enumerated()), id: \.offset) { index, hour in
                if isEditing {
                    RowTime(item: $viewModel.hours[index], isEditing: isEditing)
                } else {
                    NavigationLink(
                        destination: Text("Hello"),
                        label: { RowTime(item: $viewModel.hours[index], isEditing: false) }
                    )
                }
            }.listStyle(.plain)
            if isEditing {
                Button("Siguiente", action: { self.nagivationNextView() })
                    .foregroundColor(.white)
                    .padding(.all)
                    .frame(maxWidth: .infinity, maxHeight: 36)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            NavigationLink(
                destination: Text("Hello"),
                isActive: $nextView,
                label: { EmptyView() }
            )
        } // Main VStack
        .padding(.horizontal)
        .navigationTitle("Reservation Date")
        .navigationBarItems(
            trailing:
                Button(
                    action: { isEditing.toggle() },
                    label: {
                        if isEditing {
                            Text("Cancel")
                        } else {
                            Text("Edit")
                        }
                    }
                )
        )
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
    }
    
    private func nagivationNextView() {
        if viewModel.isAtLeastOneItemSelected() {
            self.nextView = true
        } else {
            Utils.showBarnner(
                title: "There are no selected times",
                subtitle: "Please select at least one time before continuing."
            )
        }
    }
}

struct HoursAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationDateSelectorView(restaurant: RestaurantModel(id: "1", name: "Lido Bar", address: "Asunción"))
    }
}

struct RowTime: View {
    @Binding var item: Time
    let isEditing: Bool
    
    var body: some View {
        HStack {
            if isEditing {
                Button(action: {
                    item.isSelected.toggle()
                }) {
                    if item.isSelected {
                        Image(systemName: "checkmark.circle.fill")
                    } else {
                        Image(systemName: "circle")
                    }
                }
            }
            Text("\(item.startTime):00 - \(item.endTime):00")
        }
    }
}
