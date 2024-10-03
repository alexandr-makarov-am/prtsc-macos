//
//  BarMenuView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct BarMenuView: View {
    
    @State private var selectedArea: NSRect = NSRect()
    @State private var shownCastSelector = false
    @State private var shownShotSelector = false
    
    private var screen: NSScreen? = NSScreen.screens.first
    
    var body: some View {
        VStack {
            Button {
                // openWindow(id: "MainView")
            } label: {
                Text(String(localized: "app.open"))
            }

            Button {
                shownShotSelector.toggle()
            } label: {
                Text(String(localized: "screenshot.take"))
            }.areaSelector(isShown: $shownShotSelector, selectedArea: $selectedArea, contentRect: screen!.frame) {
                ScreenshotView(selectedArea: $selectedArea, shownAreaSelector: $shownShotSelector)
            }

            Button {
                shownCastSelector.toggle()
            } label: {
                Text(String(localized: "screencast.record"))
            }.areaSelector(isShown: $shownCastSelector, selectedArea: $selectedArea, contentRect: screen!.frame) {
                ScreencastView(selectedArea: $selectedArea, shownAreaSelector: $shownCastSelector)
            }

            Button {
                exit(0);
            } label: {
                Text(String(localized: "app.quit"))
            }
        }
    }
}
