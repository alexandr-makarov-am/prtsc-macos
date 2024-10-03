//
//  ContentView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext)
    private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationSplitView {
            // todo
        } detail: {
            BarMenuView()
        }.toolbar {
           // todo
        }
    }
}

#Preview {
    MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
