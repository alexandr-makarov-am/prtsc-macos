//
//  AppUtils.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 5.10.24.
//

import Foundation

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
}
