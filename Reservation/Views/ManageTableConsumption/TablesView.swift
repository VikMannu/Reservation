//
//  TablesView.swift
//  Reservation
//
//  Created by Victor Ayala on 2023-06-08.
//

import SwiftUI

struct TablesView: View {
    @StateObject var viewModel = TablesViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    @State private var goToBusyTableView: Bool = false
    @State private var goToClientsView: Bool = false
    
    var filteredTables: [TableModel] {
        if searchText.isEmpty {
            return viewModel.tables
        }
        return viewModel.tables.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search view
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
                        
                        Button(
                            action: { self.searchText = "" },
                            label: { Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1) }
                        )
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
                
                // List View
                List(filteredTables, id: \.id) { table in
                    Button(
                        action: { self.getStatusTable(table: table) },
                        label: { RowTableMin(table: table) }
                    )
                }
                
                 NavigationLink(
                    isActive: $goToBusyTableView,
                    destination: { BusyTableView(table: viewModel.selectedTable) },
                    label: {}
                 )
                
                NavigationLink(
                   isActive: $goToClientsView,
                   destination: { ClientsView(delegate: self) },
                   label: {}
                )
            }.navigationBarTitle(Text("Tables"))
        }
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
            viewModel.getTables()
        }
    }
    
    private func getStatusTable(table: TableModel) {
        viewModel.selectedTable = table
        viewModel.getStatusTable() { status in
            if status == .busy {
                self.goToBusyTableView = true
            } else if status == .available {
                self.goToClientsView = true
            }
        }
    }
}

extension TablesView: ClientsViewDelegate {
    func selectedClient(client: ClientModel) {
        self.goToClientsView = false
        viewModel.openTable(client: client) { statusOpenTable in
            if statusOpenTable == .success {
                self.goToBusyTableView = true
            }
        }
    }
}

struct TablesView_Previews: PreviewProvider {
    static var previews: some View {
        TablesView()
    }
}
