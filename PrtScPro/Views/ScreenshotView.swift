//
//  ScreenshotView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct ScreenshotView: View {
    @ObservedObject var model: ScreenAreaModel

    var body: some View {
        ZStack {
            HStack {
                ControlButton(systemIconName: "checkmark.circle")
                    .onTapGesture {
                        model.isShown.toggle()
                    }
                ControlButton(systemIconName: "xmark.circle")
                    .onTapGesture {
                        model.isShown.toggle()
                    }
            }
        }
        .padding(10)
        .background(.gray, in: RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    @ObservedObject var model = ScreenAreaModel()
    return ScreenshotView(model: model)
}
