//
//  ScreenAreaModel.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 3.10.24.
//

import Foundation

class ScreenAreaModel: ObservableObject {
    @Published var selectedArea: NSRect = NSRect()
    @Published var isShown: Bool = false
    @Published var ignoreMouseEvents: Bool = false
}
