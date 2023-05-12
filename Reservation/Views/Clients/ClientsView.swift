//
//  ClientsView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

enum BackClient {
    case filterView
    case hoursAvailableView
}

struct ClientsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModelFilter: ReservationsViewModel
    @StateObject var viewModel = ClienstViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var isPresented = false
    
    @State private var showingAddClient = false
    
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
                FloatingActionButton(action: { self.showingAddClient = true})
                if viewModel.isLoading {
                    Color.gray.opacity(0.7)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
        )
        .sheet(
            isPresented: $showingAddClient,
            onDismiss: { self.viewModel.getClients() },
            content: { AddClientView() }
        )
        .onAppear {
            self.viewModel.getClients()
        }
    }
}

struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView(viewModelFilter: ReservationsViewModel(restaurant: RestaurantModel(id: "1", name: "Lido Bar", address: "Asunción")))
    }
}

struct FloatingActionButton: View {
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: "plus")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
            }
        }.padding(.horizontal)
    }
}
