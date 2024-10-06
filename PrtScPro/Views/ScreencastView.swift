//
//  ControlsView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct ScreencastView: View {
    
    @ObservedObject var model: ScreenAreaModel
    @State var isStarted: Bool = false
    @State var isFrozen: Bool = false
    
    var body: some View {
        let started = isStarted && !isFrozen,
            paused = isStarted && isFrozen,
            stopped = !isStarted && !isFrozen
        ZStack {
            HStack {
                TimerView(isStarted: isStarted, isFrozen: isFrozen)
                Divider().frame(width: 1, height: 40)
                ControlButton(isDisabled: started, systemIconName: "record.circle")
                    .disabled(started)
                    .onTapGesture {
                        isFrozen = false
                        isStarted = true
                        // todo
                    }
                ControlButton(isDisabled: paused, systemIconName: "pause.circle")
                    .disabled(paused)
                    .onTapGesture {
                        isFrozen = true
                        isStarted = true
                        // todo
                    }
                ControlButton(isDisabled: stopped, systemIconName: "stop.circle")
                    .disabled(stopped)
                    .onTapGesture {
                        isFrozen = false
                        isStarted = false
                        // todo
                    }
                ControlButton(isDisabled: !stopped, systemIconName: "xmark.circle")
                    .disabled(!stopped)
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
    return ScreencastView(model: model)
}

