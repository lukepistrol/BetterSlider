//
//  BetterSliderView.swift
//  BetterSliderDemo
//
//  Created by Lukas Pistrol on 23.12.23.
//

import SwiftUI
import BetterSlider

struct BetterSliderView: View {

    @State private var value: Double = 0.5
    private let step = 0.1
    private let range = 0.0...1.0

    var body: some View {
        List {
            BetterSlider(value: $value, in: range, step: step) {
                Button {
                    value -= step
                } label: {
                    Image(systemName: "minus")
                }
                .disabled(value - step < range.lowerBound)
                
            } maximumValueLabel: {
                Button {
                    value += step
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(value + step > range.upperBound)
            }
            .showSliderStep()
            .sliderHandleSize(20)
            .sliderTrackHeight(10)
            .sliderStepHeight(25)
            .sliderTrackColor(.gray)
            .sliderHandleColor(.red)
            .tint(.mint)
            .padding()
            BetterSlider(value: $value, in: range)
                .showSliderStep()
                .padding()
        }
        .safeAreaInset(edge: .top) {
            Text(value, format: .number.precision(.fractionLength(1...4)))
                .font(.system(size: 68, weight: .bold, design: .rounded).monospacedDigit())
                .padding()
                .contentTransition(.numericText(value: value))
                .animation(.default, value: value)
        }
    }

}

struct RangeSliderView: View {

    @State private var value: ClosedRange<Double> = 20...80
    private let step = 10.0
    private let range = 0.0...100.0

    var body: some View {
        List {
            RangeSlider(selection: $value, in: range, step: step) {
                Text(range.lowerBound, format: .number)
            } maximumValueLabel: {
                Text(range.upperBound, format: .number)
                    .monospacedDigit()
            }
                .showSliderStep()
                .sliderHandleSize(20)
                .sliderTrackHeight(10)
                .sliderStepHeight(25)
                .sliderTrackColor(.gray)
                .sliderHandleColor(lower: .red, upper: .purple)
                .tint(.mint)
                .padding()
            RangeSlider(selection: $value, in: range)
                .padding()
        }
        .safeAreaInset(edge: .top) {
            Text("\(value.lowerBound.formatted(.number.precision(.fractionLength(0)))) - \(value.upperBound.formatted(.number.precision(.fractionLength(0))))")
                .font(.system(size: 56, weight: .bold, design: .rounded).monospacedDigit())
                .padding()
                .contentTransition(.numericText())
                .animation(.default, value: value)
        }
    }
}

#Preview {
    ContentView()
}
