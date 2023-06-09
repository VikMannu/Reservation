//
//  ContentView.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-08.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        TabView {
            RestaurantsView(restaurantDestination: .filterView)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Reservations")
                }
            
            RestaurantsView(restaurantDestination: .hoursAvailableView)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add Reservation")
                }
            
            TablesView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Manage Consumption")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
