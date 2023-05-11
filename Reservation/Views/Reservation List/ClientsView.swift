//
//  ClientsView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct ClientsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModelFilter: FilterViewModel
    @StateObject var viewModel = ClienstViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var filteredClients: [ClientModel] {
        if searchText.isEmpty {
            return viewModel.clients
        } else {
            return viewModel.clients.filter {
                let all = ($0.name ?? "") + ($0.surname ?? "") + ($0.ci ?? "")
                return all.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        VStack {
            //Search View
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField(
                        "Search",
                        text: $searchText,
                        onEditingChanged: { isEditing in
                            self.showCancelButton = true
                        }
                    ).foregroundColor(.primary)
                    
                    Button(action: {
                        self.searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                
                if showCancelButton  {
                    Button("Cancel") {
                        UIApplication.shared.endEditing(true)
                        self.searchText = ""
                        self.showCancelButton = false
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
            .padding(.horizontal)
            .navigationBarHidden(showCancelButton)
            
            // List Clients
            List(filteredClients, id: \.id) { client in
                Text("\(client.ci ?? "") | \(client.name ?? "") \(client.surname ?? "")")
                    .onTapGesture {
                        viewModelFilter.selectedClientTitle = "\(client.ci ?? "") | \(client.name ?? "") \(client.surname ?? "")"
                        viewModelFilter.selectedClient = client
                        presentationMode.wrappedValue.dismiss()
                    }
            }
        } // Main VStack
        .navigationTitle("Clients")
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

struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView(viewModelFilter: FilterViewModel(restaurant: RestaurantModel(id: "1", name: "Lido Bar", address: "Asunción")))
    }
}
