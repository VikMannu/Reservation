//
//  ClientsView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

enum NextClient {
    case reservationsView
    case availableSchedulesView
    case busyTableView
    case openTable
}

struct ClientsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModelFilterReservations: ReservationsViewModel
    @ObservedObject var viewModelFilterAvailableShedules: AvailableSchedulesViewModel
    @ObservedObject var viewModelFilterBusyTable: BusyTableViewModel
    @StateObject var viewModel: ClienstViewModel
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var isPresented = false
    
    @State private var showingAddClient = false
    @State private var goToBusyTable = false
    
    let nextClient: NextClient
    
    init(table: TableModel) {
        self.nextClient = .openTable
        self._viewModel = StateObject(wrappedValue: ClienstViewModel(table: table))
        self.viewModelFilterReservations = ReservationsViewModel(restaurant: RestaurantModel(id: 0, name: "", address: ""))
        self.viewModelFilterAvailableShedules = AvailableSchedulesViewModel(availableSchedule: RequestAvailableSchedulesModel())
        self.viewModelFilterBusyTable = BusyTableViewModel(table: TableModel())
    }
    
    init(viewModelFilter: ReservationsViewModel) {
        self.nextClient = .reservationsView
        self._viewModel = StateObject(wrappedValue: ClienstViewModel())
        self.viewModelFilterReservations = viewModelFilter
        self.viewModelFilterAvailableShedules = AvailableSchedulesViewModel(availableSchedule: RequestAvailableSchedulesModel())
        self.viewModelFilterBusyTable = BusyTableViewModel(table: TableModel())
    }
    
    init(viewModelFilter: AvailableSchedulesViewModel) {
        self.nextClient = .availableSchedulesView
        self._viewModel = StateObject(wrappedValue: ClienstViewModel())
        self.viewModelFilterAvailableShedules = viewModelFilter
        self.viewModelFilterReservations = ReservationsViewModel(restaurant: RestaurantModel(id: 0, name: "", address: ""))
        self.viewModelFilterBusyTable = BusyTableViewModel(table: TableModel())
    }
    
    init(viewModelFilter: BusyTableViewModel) {
        self.nextClient = .busyTableView
        self._viewModel = StateObject(wrappedValue: ClienstViewModel())
        self.viewModelFilterBusyTable = viewModelFilter
        self.viewModelFilterAvailableShedules = AvailableSchedulesViewModel(availableSchedule: RequestAvailableSchedulesModel())
        self.viewModelFilterReservations = ReservationsViewModel(restaurant: RestaurantModel(id: 0, name: "", address: ""))
    }
    
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
                        let titleClient = "\(client.ci ?? "") | \(client.name ?? "") \(client.surname ?? "")"
                        if nextClient == .reservationsView {
                            viewModelFilterReservations.selectedClient = client
                            viewModelFilterReservations.selectedClientTitle = titleClient
                            presentationMode.wrappedValue.dismiss()
                        } else if nextClient == .availableSchedulesView {
                            viewModelFilterAvailableShedules.selectedClient = client
                            viewModelFilterAvailableShedules.selectedClientTitle = titleClient
                            presentationMode.wrappedValue.dismiss()
                        } else if nextClient == .busyTableView {
                            viewModelFilterBusyTable.selectedClient = client
                            presentationMode.wrappedValue.dismiss()
                        } else if nextClient == .openTable {
                            self.openTable(client: client)
                        }
                    }
            }
            
            NavigationLink(
                isActive: $goToBusyTable,
                destination: { BusyTableView(table: viewModel.selectedTable ?? TableModel()) },
                label: {}
            )
        } // Main VStack
        .navigationTitle("Clients")
        .overlay(
            ZStack {
                FloatingActionButton(nameImage: "plus", action: { self.showingAddClient = true })
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
    
    private func openTable(client: ClientModel) {
        viewModel.openTable(client: client) { statusOpenTable in
            if statusOpenTable == .success {
                self.goToBusyTable = true
            }
        }
    }
}

struct ClientsView_Previews: PreviewProvider {
    static var previews: some View {
        ClientsView(viewModelFilter: ReservationsViewModel(restaurant: RestaurantModel(id: 1, name: "Lido Bar", address: "Asunción")))
    }
}

struct FloatingActionButton: View {
    let nameImage: String
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: action) {
                    Image(systemName: nameImage)
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
