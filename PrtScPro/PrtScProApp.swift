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
    
    @State var isInserted: Bool = true;
    
    var body: some Scene {
        MenuBarExtra(isInserted: $isInserted) {
            BarMenuView()
        } label: {
            // Image(systemName: "photo.fill").renderingMode(.template)
            Image("BarIcon").renderingMode(.template)
        }
        .menuBarExtraStyle(.window)
        
        WindowGroup(id: "MainView") {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
