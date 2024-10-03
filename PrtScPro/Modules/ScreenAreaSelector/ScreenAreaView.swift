//
//  ScreenAreaView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

class ScreenAreaView: NSView {
    
    private var rect: NSRect
    private var onChange: (_ rect: NSRect) -> Void
    private var startPoint: NSPoint?
    
    override var acceptsFirstResponder: Bool { true }
    
    init(frame frameRect: NSRect, onChange: @escaping (_ rect: NSRect) -> Void) {
        self.rect = NSRect(x: 0, y: 0, width: 0, height: 0)
        self.onChange = onChange
        super.init(frame: frameRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSGraphicsContext.current?.compositingOperation = .copy
        NSColor.black.withAlphaComponent(0.5).setFill()
        
        dirtyRect.fill()

        let context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(red: 1, green: 1, blue: 1, alpha: 0.01)
        context?.fill(self.rect)
    }
    
    override func mouseDown(with event: NSEvent) {
        self.startPoint = convert(event.locationInWindow, from: nil)
    }
    
    override func mouseUp(with event: NSEvent) {
        self.startPoint = nil
    }
    
    override func mouseDragged(with event: NSEvent) {
        let current = convert(event.locationInWindow, from: nil)
        if let previous = self.startPoint {
            self.rect.origin.x = previous.x
            self.rect.origin.y = previous.y
            self.rect.size.width = current.x - previous.x
            self.rect.size.height = current.y - previous.y
            self.onChange(rect)
        }
        self.needsDisplay = true
    }
}
