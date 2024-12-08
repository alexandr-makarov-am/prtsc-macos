//
//  ScreenAreaPanelModifier.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

fileprivate struct ScreenAreaPanelModifier<T: View>: ViewModifier {
    
    @Binding var isShown: Bool
    @Binding var ignoreMouseEvents: Bool
    @Binding var selectedArea: NSRect
    @ViewBuilder let view: () -> T
    let contentRect: CGRect
    
    @State var panel: ScreenAreaPanel<T>?
    @State var timer: Timer?
    
    func body(content: Content) -> some View {
        content.onAppear {
            if isShown {
                createPanel()
            }
        }.onDisappear {
            destroyPanel()
        }.onChange(of: isShown) { _, value in
            if value {
                createPanel()
            } else {
                destroyPanel()
            }
        }
    }
    
    private func createPanel() {
        panel = ScreenAreaPanel(contentRect: contentRect, selectedArea: $selectedArea, view: view)
        if let nsPanel = panel {
            nsPanel.orderFrontRegardless()
            panel = nsPanel
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true, block: { _ in
            panel?.ignoresMouseEvents = ignoreMouseEvents
        })
    }
    
    private func destroyPanel() {
        if let nsPanel = panel {
            nsPanel.close()
            panel = nil
        }
        timer?.invalidate()
        timer = nil
    }
}

extension View {
    func areaSelector<T: View>(
        isShown: Binding<Bool>,
        selectedArea: Binding<NSRect>,
        contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512),
        ignoreMouseEvents: Binding<Bool>,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        self.modifier(ScreenAreaPanelModifier(isShown: isShown, ignoreMouseEvents: ignoreMouseEvents, selectedArea: selectedArea, view: content, contentRect: contentRect))
    }
}
