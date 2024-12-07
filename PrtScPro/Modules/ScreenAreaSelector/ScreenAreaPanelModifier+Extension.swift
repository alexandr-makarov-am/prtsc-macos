//
//  ScreenAreaPanelModifier.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

fileprivate struct ScreenAreaPanelModifier<T: View>: ViewModifier {
    
    @Binding var isShown: Bool
    @Binding var selectedArea: NSRect
    @ViewBuilder let view: () -> T
    
    @State var panel: ScreenAreaPanel<T>?
    
    var contentRect: CGRect
    
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
        }.onChange(of: selectedArea) { _, rect in
            let x0 = rect.minX,
                y0 = rect.minY,
                offset: CGFloat = 80
            if isShown {
                panel?.showControlsView(
                    x: AppUtils.getSafeValue(x0, min: contentRect.minX, max: contentRect.maxX - rect.width),
                    y: AppUtils.getSafeValue(y0 - offset, min: contentRect.minY + offset, max: contentRect.maxY),
                    width: AppUtils.getSafeValue(rect.width, min: 0, max: contentRect.width),
                    height: AppUtils.getSafeValue(50, min: 0, max: contentRect.height)
                )
            }
        }
    }
    
    private func createPanel() {
        panel = ScreenAreaPanel(contentRect: contentRect, selectedArea: $selectedArea, view: view)
        if let nsPanel = panel {
            nsPanel.orderFrontRegardless()
            panel = nsPanel
        }
    }
    
    private func destroyPanel() {
        if let nsPanel = panel {
            nsPanel.close()
            panel = nil
        }
    }
}

extension View {
    func areaSelector<T: View>(
        isShown: Binding<Bool>,
        selectedArea: Binding<NSRect>,
        contentRect: CGRect = CGRect(x: 0, y: 0, width: 624, height: 512),
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        self.modifier(ScreenAreaPanelModifier(isShown: isShown, selectedArea: selectedArea, view: content, contentRect: contentRect))
    }
}
