//
//  ControlButton.swift
//  PrtScPro
//
//  Created by Alexandr Makarov on 2.10.24.
//

import SwiftUI

struct ControlButton: View {
    
    @State var isHover: Bool = false
    
    var isDisabled: Bool = false
    var systemIconName: String
    
    var body: some View {
        Image(systemName: systemIconName)
            .frame(width: 48, height: 48)
            .background(isHover && !isDisabled ? .white : .clear)
            .foregroundColor(isHover && !isDisabled ? .gray : .white)
            .opacity(isDisabled ? 0.5 : 1.0)
            .font(.system(size: 28))
            .cornerRadius(12)
            .onHover(perform: { hovering in
                withAnimation {
                    isHover.toggle()
                }
            })
    }
}
