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
                
                // List View
                List(filteredTables, id: \.id) { table in
                    NavigationLink(
                        destination: { BusyTableView(table: table) },
                        label: { RowTableMin(table: table) }
                    )
                }
                
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
}

struct TablesView_Previews: PreviewProvider {
    static var previews: some View {
        TablesView()
    }
}
