//
//  ScreenAreaPanel.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

class ScreenAreaPanel<Content: View>: NSPanel {
    private var controls: NSHostingView<Content>?
    
    init(contentRect: NSRect, selectedArea: Binding<NSRect>, @ViewBuilder view: () -> Content) {
        super.init(contentRect: contentRect, styleMask: [.borderless, .nonactivatingPanel, .closable, .fullSizeContentView], backing: .buffered, defer: false)
        self.isOpaque = false
        self.hasShadow = false
        self.level = .statusBar
        self.isRestorable = false
        self.backgroundColor = .clear
        self.isReleasedWhenClosed = false
        self.isMovableByWindowBackground = false
        self.collectionBehavior = [.fullScreenAuxiliary, .canJoinAllSpaces]
        self.contentView = ScreenAreaView(frame: contentRect, rect: selectedArea)
        
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
