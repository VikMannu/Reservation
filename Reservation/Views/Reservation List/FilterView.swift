//
//  FilterView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct FilterView: View {
    let currentDate = Date()
    
    @State private var selectedDate = Date()
    @State private var selectedClient = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                    .foregroundColor(Color.blue)
                ZStack(alignment: .center, content: {
                    HStack {
                        TextField("Seleccionar Cliente", text: $selectedClient)
                            .padding(.horizontal)
                        Image(systemName: "arrow.right")
                            .padding(.horizontal)
                            .foregroundColor(Color.gray)
                    }
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
                    "Selecciona una fecha:",
                    selection: $selectedDate,
                    in: ...currentDate,
                    displayedComponents: [.date]
                )
                .padding(.horizontal)
                Divider()
                    .foregroundColor(Color.blue)
                Spacer()
            } // main VStack
            .navigationBarTitle(Text("Lista de Reservas"))
        } // NavigationView
    } // Body
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
