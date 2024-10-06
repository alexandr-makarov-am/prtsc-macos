//
//  ScreenAreaView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 1.10.24.
//

import SwiftUI

fileprivate enum ScreenAreaAction {
    case draw, move
}

fileprivate struct ScreenAreaSnapshot {
    var rect = NSRect()
    var point = NSPoint()
    var action = ScreenAreaAction.draw
}

fileprivate class ScreenSelectArea {
    @Binding var rect: NSRect
    var points: Array<NSRect> = []

    init(rect: Binding<NSRect>) {
        _rect = rect
        for _ in 0...8 {
            points.append(NSRect())
        }
    }
    
    private func prepare(r: NSRect, x: CGFloat, y: CGFloat, w: CGFloat?, h: CGFloat?) -> NSRect {
        var _rect = r
        _rect.origin.x = x
        _rect.origin.y = y
        if (w != nil) {
            _rect.size.width = w!
        }
        if (h != nil) {
            _rect.size.height = h!
        }
        return _rect;
    }
    
    func setRectPosition(x: CGFloat, y: CGFloat, w: CGFloat? = nil, h: CGFloat? = nil) -> Void {
       
        rect = prepare(r: rect, x: x, y: y, w: w, h: h)
        
        let pointSize: CGFloat = 10,
            pointRadius = pointSize / 2,
            cx = rect.midX - pointRadius,
            cy = rect.midY - pointRadius,
            rw = rect.width / 2,
            rh = rect.height / 2
        
        points = points.enumerated().map { (key, value) in
            var point = value
            switch key {
            case 0:
                point = prepare(r: point, x: cx - rw, y: cy + rh , w: pointSize, h: pointSize)
                break
            case 1:
                point = prepare(r: point, x: cx, y: cy + rh, w: pointSize, h: pointSize)
                break
            case 2:
                point = prepare(r: point, x: cx + rw, y: cy + rh, w: pointSize, h: pointSize)
                break
            case 4:
                point = prepare(r: point, x: cx + rw, y: cy, w: pointSize, h: pointSize)
                break
            case 5:
                point = prepare(r: point, x: cx + rw, y: cy - rh, w: pointSize, h: pointSize)
                break
            case 6:
                point = prepare(r: point, x: cx, y: cy - rh, w: pointSize, h: pointSize)
                break
            case 7:
                point = prepare(r: point, x: cx - rw, y: cy - rh, w: pointSize, h: pointSize)
                break
            case 8: 
                point = prepare(r: point, x: cx - rw, y: cy, w: pointSize, h: pointSize)
                break
            default:
                break
            }
            return point
        }
    }
    
    func draw(context: CGContext) {
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 0.01)
        context.fill([rect])
        context.setFillColor(red: 1, green: 0, blue: 0, alpha: 0.9)
        for point in points {
            context.fillEllipse(in: point)
        }
    }
}

class ScreenAreaView: NSView {
    
    private var context: CGContext?
    private var temp: ScreenAreaSnapshot?
    private var selectArea: ScreenSelectArea
    
    override var acceptsFirstResponder: Bool { true }
    
    init(frame frameRect: NSRect, rect: Binding<NSRect>) {
        selectArea = ScreenSelectArea(rect: rect)
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
        
        context = NSGraphicsContext.current?.cgContext
        if let ctx = context {
            selectArea.draw(context: ctx)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        let point = event.locationInWindow
        var snapshot = ScreenAreaSnapshot()
        if (selectArea.rect.contains(point)) {
            snapshot.action = .move
            snapshot.rect = selectArea.rect
        } else {
            snapshot.action = .draw
        }
        snapshot.point = point
        temp = snapshot
    }
    
    override func mouseUp(with event: NSEvent) {
        temp = nil
    }
    
    override func mouseDragged(with event: NSEvent) {
        let current = event.locationInWindow
        if (temp?.action == .draw) {
            if let previous = temp?.point {
                selectArea.setRectPosition(x: previous.x, y: previous.y, w: current.x - previous.x, h: current.y - previous.y)
            }
        }
        if (temp?.action == .move) {
            if let previous = temp?.point, let prevRect = temp?.rect {
                let x = prevRect.origin.x + (current.x - previous.x)
                let y = prevRect.origin.y + (current.y - previous.y)
                selectArea.setRectPosition(
                    x: AppUtils.getSafeValue(x, min: frame.minX, max: frame.maxX - selectArea.rect.width),
                    y: AppUtils.getSafeValue(y, min: frame.minY + selectArea.rect.height, max: frame.maxY)
                )
            }
        }
        self.needsDisplay = true
    }
}
