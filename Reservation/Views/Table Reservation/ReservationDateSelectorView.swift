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
            List(Array(viewModel.schedules.enumerated()), id: \.offset) { index, schedule in
                if isEditing {
                    RowTime(item: $viewModel.schedules[index], isEditing: isEditing)
                } else {
                    NavigationLink(
                        destination: AvailableSchedulesView(
                            availableSchedule: RequestAvailableSchedulesModel(
                                restaurantId: viewModel.restaurant.id ?? 0,
                                date: viewModel.selectedDate,
                                schedules: [schedule]
                            )
                        ),
                        label: { RowTime(item: $viewModel.schedules[index], isEditing: false) }
                    )
                }
            }.listStyle(.plain)
            if isEditing {
                Button("Following", action: { self.nagivationNextView() })
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
            NavigationLink(
                destination: AvailableSchedulesView(
                    availableSchedule: RequestAvailableSchedulesModel(
                        restaurantId: viewModel.restaurant.id ?? 0,
                        date: viewModel.selectedDate,
                        schedules: viewModel.getSelectedSchedules()
                    )
                ),
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
        ReservationDateSelectorView(restaurant: RestaurantModel(id: 1, name: "Lido Bar", address: "Asunción"))
    }
}

struct RowTime: View {
    @Binding var item: Schedule
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
