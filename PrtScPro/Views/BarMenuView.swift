//
//  BarMenuView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct BarMenuView: View {
    @Environment(\.openWindow) private var openWindow
    @ObservedObject var shotModel = ScreenAreaModel()
    @ObservedObject var castModel = ScreenAreaModel()
    
    private var screen: NSScreen? = NSScreen.screens.first
    
    var body: some View {
        VStack {
            Button {
                shotModel.isShown.toggle()
            } label: {
                Text(String(localized: "screenshot.take"))
            }.areaSelector(isShown: $shotModel.isShown, selectedArea: $shotModel.selectedArea, contentRect: screen!.frame, ignoreMouseEvents: $shotModel.ignoreMouseEvents) {
                ScreenshotView(model: shotModel)
            }
            Button {
                castModel.isShown.toggle()
            } label: {
                Text(String(localized: "screencast.record"))
            }.areaSelector(isShown: $castModel.isShown, selectedArea: $castModel.selectedArea, contentRect: screen!.frame,  ignoreMouseEvents: $castModel.ignoreMouseEvents) {
                ScreencastView(model: castModel)
            }
            Divider()
            Button {
                exit(0);
            } label: {
                Text(String(localized: "app.quit"))
            }
        }.padding(15)
    }
}
