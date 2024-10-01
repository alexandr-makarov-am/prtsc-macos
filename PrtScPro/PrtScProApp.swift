//
//  PrtScProApp.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

@main
struct PrtScProApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
