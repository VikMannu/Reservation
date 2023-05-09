//
//  RestaurantsView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

struct RestaurantsView: View {
    @StateObject var viewModel = RestaurantsViewModel()
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var filteredRestaurants: [Restaurant] {
        if searchText.isEmpty {
            return viewModel.restaurants
        } else {
            return viewModel.restaurants.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search view
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        TextField(
                            "Buscar",
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
                        Button("Cancelar") {
                            UIApplication.shared.endEditing(true)
                            self.searchText = ""
                            self.showCancelButton = false
                        }
                        .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.horizontal)
                .navigationBarHidden(showCancelButton)
                
                // List view
                List(filteredRestaurants, id: \.id) { restaurant in
                    NavigationLink(destination: Text(restaurant.id ?? "")) {
                        Text(restaurant.name ?? "")
                    }
                }
            }.navigationBarTitle(Text("Restaurantes"))
        }
    }
}

struct RestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantsView()
    }
}