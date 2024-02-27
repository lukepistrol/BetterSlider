//
//  TrackView.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 26.02.24.
//

import SwiftUI

struct TrackView: View {

    @Environment(\.sliderTrackHeight) private var sliderTrackHeight
    @Environment(\.sliderTrackColor) private var sliderTrackColor

    let step: Double.Stride?
    let range: ClosedRange<Double>
    let offsetTrailing: Double
    let offsetLeading: Double

    init(
        step: Double.Stride?,
        range: ClosedRange<Double>,
        offset: Double
    ) {
        self.step = step
        self.range = range
        self.offsetTrailing = offset
        self.offsetLeading = 0
    }

    init(
        step: Double.Stride?,
        range: ClosedRange<Double>,
        offsets: (Double, Double)
    ) {
        self.step = step
        self.range = range
        self.offsetTrailing = offsets.1
        self.offsetLeading = offsets.0
    }

    var body: some View {
        ZStack {
            StepMarksView(step: step, range: range)
            Rectangle()
                .frame(height: sliderTrackHeight)
                .foregroundStyle(sliderTrackColor)
                .overlay(alignment: .leading) {
                    Rectangle()
                        .foregroundStyle(.tint)
                        .padding(.trailing, offsetTrailing)
                        .padding(.leading, offsetLeading)
                }
                .clipShape(Capsule(style: .circular))
                .padding(.horizontal, 1)
        }
    }
}

struct StepMarksView: View {

    @Environment(\.showSliderStep) private var showSliderStep
    @Environment(\.sliderTrackColor) private var sliderTrackColor
    @Environment(\.sliderHandleSize) private var sliderHandleSize
    @Environment(\.sliderStepHeight) private var sliderStepHeight

    let step: Double.Stride?
    let range: ClosedRange<Double>

    @ViewBuilder
    var body: some View {
        if let step, showSliderStep {
            HStack(spacing: 0) {
                ForEach(0...Int((range.upperBound - range.lowerBound) / step), id: \.self) { value in
                    if value != 0 {
                        Spacer(minLength: 0)
                    }
                    VStack {
                        Capsule()
                            .frame(width: 2)
                            .foregroundStyle(sliderTrackColor)
                            .frame(height: sliderStepHeight ?? (sliderHandleSize * 0.8))
                    }
                    if value < Int((range.upperBound - range.lowerBound) / step) {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding(.horizontal, sliderHandleSize / 2)
        }
    }
}
