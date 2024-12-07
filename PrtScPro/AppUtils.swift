//
//  AppUtils.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 5.10.24.
//

import Foundation
import ScreenCaptureKit

struct AppUtils {
    static func getSafeValue(_ value: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
        if (value < min) {
            return min
        } else if (value > max) {
            return max
        } else {
            return value
        }
    }
    
    static func convertRectCoords(_ rect: CGRect, display: SCDisplay) -> CGRect {
        let x = rect.minX
        let y = abs(rect.minY - CGFloat(display.height) + rect.height)
        return CGRect(x: x, y: y, width: abs(rect.width), height: abs(rect.height));
    }
}
