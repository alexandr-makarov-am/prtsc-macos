//
//  ControlsView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct ScreencastView: View {
    
    @Binding var selectedArea: NSRect
    @Binding var shownAreaSelector: Bool

    @State var isStarted: Bool = false
    @State var isFrozen: Bool = false
    
    @State var recorder: ScreenRecorder?
    
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
                        recorder = ScreenRecorder(rect: selectedArea)
                        recorder?.record()
                    }
                ControlButton(isDisabled: paused, systemIconName: "pause.circle")
                    .disabled(paused)
                    .onTapGesture {
                        isFrozen = true
                        isStarted = true
                    }
                ControlButton(isDisabled: stopped, systemIconName: "stop.circle")
                    .disabled(stopped)
                    .onTapGesture {
                        isFrozen = false
                        isStarted = false
                        Task {
                            try await recorder?.stop();
                        }
                    }
                ControlButton(isDisabled: !stopped, systemIconName: "xmark.circle")
                    .disabled(!stopped)
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
    return ScreencastView(selectedArea: $selectedArea, shownAreaSelector: $shownAreaSelector)
}

