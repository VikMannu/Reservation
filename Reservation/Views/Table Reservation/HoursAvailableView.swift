//
//  HoursAvailableView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import SwiftUI

struct HoursAvailableView: View {
    @StateObject var viewModel = HoursAvailableViewModel()
    
    @State private var isEditing = false
    
    private let currentDate = Date()
    
    var body: some View {
        VStack {
            DatePicker(
                "Select date:",
                selection: $viewModel.selectedDate,
                in: currentDate...,
                displayedComponents: [.date]
            )
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        } // Main VStack
        .padding(.horizontal)
        .navigationTitle("Hours Available")
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
    }
}

struct HoursAvailableView_Previews: PreviewProvider {
    static var previews: some View {
        HoursAvailableView()
    }
}
