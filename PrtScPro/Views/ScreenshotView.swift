//
//  ScreenshotView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct ScreenshotView: View {
    @Binding var selectedArea: NSRect
    @Binding var shownAreaSelector: Bool
    
    @State var recorder: ScreenRecorder?
    
    var body: some View {
        ZStack {
            HStack {
                ControlButton(systemIconName: "checkmark.circle")
                    .onTapGesture {
                        recorder = ScreenRecorder(rect: selectedArea)
                        recorder?.screenshot()
                        shownAreaSelector.toggle()
                    }
                ControlButton(systemIconName: "xmark.circle")
                    .onTapGesture {
                        shownAreaSelector.toggle()
                    }
            }
        }
        .padding(10)
        .background(.gray, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    @State var shownAreaSelector: Bool = false
    @State var selectedArea: NSRect = NSRect()
    return ScreenshotView(selectedArea: $selectedArea, shownAreaSelector: $shownAreaSelector)
}
