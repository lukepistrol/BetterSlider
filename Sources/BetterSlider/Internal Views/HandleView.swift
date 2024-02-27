//
//  HandleView.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 26.02.24.
//

import SwiftUI

struct HandleView: View {
    @Environment(\.sliderHandleSize) private var sliderHandleSize

    let offset: Double

    var body: some View {
        Circle()
            .frame(width: sliderHandleSize)
            .shadow(color: .black.opacity(0.18), radius: 3, x: 0, y: 2.5)
            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 0)
            .offset(x: offset)
    }
}
