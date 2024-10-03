//
//  ScreenAreaPanel.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

class ScreenAreaPanel<Content: View>: NSPanel {
    
    @Binding var area: NSRect
    
    private var view: Content?
    private var controls: NSHostingView<Content>?
    
    init(contentRect: NSRect, selectedArea: Binding<NSRect>) {
        _area = selectedArea
        super.init(contentRect: contentRect, styleMask: [.borderless, .nonactivatingPanel, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        self.isOpaque = false
        self.hasShadow = false
        self.level = .statusBar
        self.isRestorable = false
        self.backgroundColor = .clear
        self.isReleasedWhenClosed = false
        self.isMovableByWindowBackground = false
        self.collectionBehavior = [.fullScreenAuxiliary, .canJoinAllSpaces]
        self.contentView = ScreenAreaView(frame: contentRect, onChange: { rect in
            let x0 = rect.minX, y0 = rect.minY, x1 = rect.maxX
            if let rootView = self.view {
                if (self.controls == nil) {
                    self.controls = NSHostingView(rootView: rootView)
                    self.contentView?.addSubview(self.controls!)
                }
                self.controls?.frame = NSRect(x: x1 , y: y0 - 70, width: x0 - x1, height: 50)
            }
            self.area = rect
        })
    }
    
    func add(@ViewBuilder view: () -> Content) {
        self.view = view()
    }
}
