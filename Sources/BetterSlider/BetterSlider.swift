//
//  BetterSlider.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 26.02.24.
//

import SwiftUI

/// A slider component that allows for more customization than the default `Slider`.
///
/// The `BetterSlider` component is a drop-in replacement for the default `Slider` component.
/// By default it looks and behaves the same as the default `Slider`. However, it allows for more
/// customization.
///
/// ![BetterSlider](BetterSlider.png)
///
/// # Example
///
/// ```swift
/// BetterSlider(value: $value, in: 0...100, step: 5) { editing in
///    print("Is editing: \(editing)")
/// }
/// ```
///
/// It is also possible to add labels to the slider:
///
/// ```swift
/// BetterSlider(value: $value, in: 0...100, step: 5) {
///   Text("0")
/// } maximumValueLabel: {
///   Text("100")
/// } onEditingChanged: { editing in
///   print("Is editing: \(editing)")
/// }
/// ```
///
/// # Customization
///
/// The `BetterSlider` component allows for the following customizations:
///
/// - The height of the slider's track - ``SwiftUI/View/sliderTrackHeight(_:)``
/// - The size of the slider's handle - ``SwiftUI/View/sliderHandleSize(_:)``
/// - The color of the slider's handle - ``SwiftUI/View/sliderHandleColor(_:)``
/// - The visibility of the step markers on the slider's track - ``SwiftUI/View/showSliderStep(_:)``
/// - The height of the step markers on the slider's track - ``SwiftUI/View/sliderStepHeight(_:)``
/// - The color of the step markers and the slider's track - ``SwiftUI/View/sliderTrackColor(_:)``
/// - Enable or disable haptic feedback - ``SwiftUI/View/hapticFeedback(_:)``
///
/// See ``SwiftUI/View`` for all available customizations.
///
/// > Info: If you want to select a `Range` instead of a single value, use the ``BetterSlider/RangeSlider`` component.
public struct BetterSlider<LowerValueLabel: View, UpperValueLabel: View>: View {

    @Environment(\.sliderTrackHeight) private var sliderTrackHeight
    @Environment(\.sliderHandleSize) private var sliderHandleSize
    @Environment(\.sliderStepHeight) private var sliderStepHeight
    @Environment(\.sliderHandleColor) private var sliderHandleStyle
    @Environment(\.hapticFeedbackEnabled) private var hapticFeedbackEnabled

    @Binding private var value: Double
    private let range: ClosedRange<Double>
    private var step: Double.Stride?
    private var minimumValueLabel: LowerValueLabel?
    private var maximumValueLabel: UpperValueLabel?
    private var onEditingChanged: (Bool) -> Void

    private func offset(forWidth width: Double, isHandle: Bool = true) -> Double {
        let rangeWidth = range.upperBound - range.lowerBound
        if isHandle {
            return ((value - range.lowerBound) / rangeWidth) * (width - sliderHandleSize)
        } else {
            return width - (
                ((value - range.lowerBound) / rangeWidth) * (width - sliderHandleSize) + sliderHandleSize / 2
            )
        }
    }

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double.Stride? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where LowerValueLabel == EmptyView, UpperValueLabel == EmptyView {
        self._value = value
        self.range = range
        self.step = step
        self.onEditingChanged = onEditingChanged
    }

    public init(
        value: Binding<Double>,
        in range: ClosedRange<Double> = 0...1,
        step: Double.Stride? = nil,
        minimumValueLabel: () -> LowerValueLabel,
        maximumValueLabel: () -> UpperValueLabel,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.onEditingChanged = onEditingChanged
    }

    public var body: some View {
        HStack {
            if let minimumValueLabel {
                minimumValueLabel
                    .buttonStyle(.borderless)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    TrackView(
                        step: step,
                        range: range,
                        offset: offset(forWidth: geo.size.width, isHandle: false)
                    )
                    HandleView(offset: offset(forWidth: geo.size.width))
                        .foregroundStyle(sliderHandleStyle.0)
                        .gesture(dragGesture(in: geo))
                }
            }
            if let maximumValueLabel {
                maximumValueLabel
                    .buttonStyle(.borderless)
            }
        }
        .frame(height: max(max(sliderHandleSize, sliderTrackHeight), sliderStepHeight ?? 0))
        .onChange(of: isEditing) { newValue in
            onEditingChanged(newValue)
        }
        .customSensoryFeedback(value: value, isEditing: isEditing, enabled: hapticFeedbackEnabled)
        .accessibilityValue(Text(value, format: .number))
    }

    @State private var isEditing = false

    private func dragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                isEditing = true
                let width = geometry.size.width - sliderHandleSize
                var offset = (value.location.x - sliderHandleSize / 2) / width
                if let step {
                    let normalizedStep = step / (range.upperBound - range.lowerBound)
                    offset = (offset / normalizedStep).rounded() * normalizedStep
                }
                self.value = max(
                    min(
                        offset * (
                            range.upperBound - range.lowerBound
                        ) + range.lowerBound,
                        range.upperBound
                    ),
                    range.lowerBound
                )
            }
            .onEnded { _ in
                isEditing = false
            }
    }
}
