//
//  AddClientView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-11.
//

import SwiftUI

struct AddClientView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel = AddClientViewModel()
    
    @State var name: String = ""
    @State var surname: String = ""
    @State var ci: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Personal information")) {
                TextField("Name", text: $name)
                TextField("Surname", text: $surname)
                TextField("CI", text: $ci)
            }
            
            Button(
                action: {
                    viewModel.addClient(with: ClientModel(id: nil, name: name, surname: surname, ci: ci))
                    self.presentationMode.wrappedValue.dismiss()
                },
                label: {
                    VStack(alignment: .center) {
                        Text("Add New Client")
                    }.frame(maxWidth: .infinity)
                }
            )
        }
        .navigationTitle("Add Client")
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

struct AddClientView_Previews: PreviewProvider {
    static var previews: some View {
        AddClientView()
    }
}
