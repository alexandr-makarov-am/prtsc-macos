//
//  ScreenAreaPanel.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

class ScreenAreaPanel<Content: View>: NSPanel {
    @Binding var selectedArea: NSRect
    private var controls: NSHostingView<Content>?
    
    init(contentRect: NSRect, selectedArea: Binding<NSRect>, @ViewBuilder view: () -> Content) {
        self._selectedArea = selectedArea
        super.init(contentRect: contentRect, styleMask: [.borderless, .nonactivatingPanel, .fullSizeContentView], backing: .buffered, defer: false)
        self.isOpaque = false
        self.hasShadow = false
        self.level = .statusBar
        self.isRestorable = false
        self.backgroundColor = .clear
        self.isReleasedWhenClosed = false
        self.isMovableByWindowBackground = false
        self.collectionBehavior = [.fullScreenAuxiliary, .canJoinAllSpaces]
        self.contentView = ScreenAreaView(frame: contentRect) { rect in
            let x0 = rect.minX,
                y0 = rect.minY,
                offset: CGFloat = 80
            self.showControlsView(
                x: AppUtils.getSafeValue(x0, min: contentRect.minX, max: contentRect.maxX - rect.width),
                y: AppUtils.getSafeValue(y0 - offset, min: contentRect.minY + offset, max: contentRect.maxY),
                width: AppUtils.getSafeValue(rect.width, min: 0, max: contentRect.width),
                height: AppUtils.getSafeValue(50, min: 0, max: contentRect.height)
            )
            self.selectedArea = rect
        }
        let content: Content? = view()
        if let rootView = content {
            controls = NSHostingView(rootView: rootView)
        }
    }
    
    func showControlsView(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        if let view = controls {
            view.frame = NSRect(x: x, y: y, width: width, height: height)
            if ((self.contentView?.subviews.isEmpty) != nil) {
                self.contentView?.addSubview(view)
            }
        }
    }
}
