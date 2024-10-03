//
//  TimerView.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct TimerView: View {
    
    @State private var time: Int = 0
    
    var isStarted: Bool
    var isFrozen: Bool
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        let minutes = String(format: "%02d", time / 60)
        let seconds = String(format: "%02d", time % 60)
        let hud = minutes + ":" + seconds
        Text(hud)
            .foregroundColor(.white)
            .font(.system(size: 18))
            .frame(width: 60, height: 48)
            .onReceive(timer, perform: { _ in
                if isStarted && !isFrozen {
                    time = time + 1
                }
            })
            .onChange(of: isStarted) { _, _ in
                time = 0
            }
    }
}
