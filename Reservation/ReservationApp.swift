//
//  ReservationApp.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-08.
//

import SwiftUI

@main
struct ReservationApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
