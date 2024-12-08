//
//  PrtScProApp.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

@main
struct PrtScProApp: App {
    @State var isInserted: Bool = true;
    var body: some Scene {
        MenuBarExtra(isInserted: $isInserted) {
            BarMenuView()
        } label: {
            Image("BarIcon").renderingMode(.template)
        }
        .menuBarExtraStyle(.menu)
    }
}
