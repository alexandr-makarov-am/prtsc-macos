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
        MenuBarExtra {
            BarMenuView()
        } label: {
            Image(systemName: "photo.fill").renderingMode(.template)
        }
        WindowGroup(id: "MainView") {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
