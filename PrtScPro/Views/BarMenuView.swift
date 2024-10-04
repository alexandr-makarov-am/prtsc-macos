//
//  BarMenuView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct BarMenuView: View {
    @Environment(\.openWindow) private var openWindow
    @StateObject var shotModel = ScreenAreaModel()
    @StateObject var castModel = ScreenAreaModel()
    
    private var screen: NSScreen? = NSScreen.screens.first
    
    var body: some View {
        VStack {
            Button {
                openWindow(id: "MainView")
            } label: {
                Text(String(localized: "app.open"))
            }

            Button {
                shotModel.isShown.toggle()
            } label: {
                Text(String(localized: "screenshot.take"))
            }.areaSelector(isShown: $shotModel.isShown, selectedArea: $shotModel.selectedArea, contentRect: screen!.frame) {
                ScreenshotView(selectedArea: $shotModel.selectedArea, shownAreaSelector: $shotModel.isShown)
            }

            Button {
                castModel.isShown.toggle()
            } label: {
                Text(String(localized: "screencast.record"))
            }.areaSelector(isShown: $castModel.isShown, selectedArea: $castModel.selectedArea, contentRect: screen!.frame) {
                ScreencastView(selectedArea: $castModel.selectedArea, shownAreaSelector: $castModel.isShown)
            }

            Button {
                exit(0);
            } label: {
                Text(String(localized: "app.quit"))
            }
        }
    }
}
