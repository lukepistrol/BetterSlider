//
//  RangeSlider.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 26.02.24.
//

import SwiftUI

/// A slider component that allows the user to select a range of values.
///
/// The ``BetterSlider/RangeSlider`` component is similar to the ``BetterSlider/BetterSlider`` component
/// but allows the user to select a range of values instead of a single value. Instead of binding a
/// `Double` value it binds a `ClosedRange<Double>`.
///
/// ![RangeSlider](RangeSlider.png)
///
/// ## Example
///
/// ```swift
/// @State var range: ClosedRange<Double> = 0...50
/// 
/// RangeSlider(selection: $range, in: 0...100, step: 5)
/// ```
///
/// ## Customization
///
/// Apart from the range selection, the same customizations as for the ``BetterSlider/BetterSlider`` component.
///
/// Since there are two handles, ``SwiftUI/View/sliderHandleColor(lower:upper:)`` can be used to color them
/// individually.
///
/// See ``SwiftUI/View`` for all available customizations.
///
public struct RangeSlider<LowerValueLabel: View, UpperValueLabel: View>: View {

    @Environment(\.sliderHandleSize) private var sliderHandleSize
    @Environment(\.sliderTrackHeight) private var sliderTrackHeight
    @Environment(\.sliderStepHeight) private var sliderStepHeight
    @Environment(\.sliderHandleColor) private var sliderHandleStyle
    @Environment(\.hapticFeedbackEnabled) private var hapticFeedbackEnabled

    @Binding private var selection: ClosedRange<Double>
    private let range: ClosedRange<Double>
    private let step: Double.Stride?
    private var onEditingChanged: (Bool) -> Void
    private var minimumValueLabel: LowerValueLabel?
    private var maximumValueLabel: UpperValueLabel?

    public init(
        selection: Binding<ClosedRange<Double>>,
        in range: ClosedRange<Double> = 0...1,
        step: Double.Stride? = nil,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where LowerValueLabel == EmptyView, UpperValueLabel == EmptyView {
        self._selection = selection
        self.range = range
        self.step = step
        self.onEditingChanged = onEditingChanged
    }

    public init(
        selection: Binding<ClosedRange<Double>>,
        in range: ClosedRange<Double> = 0...1,
        step: Double.Stride? = nil,
        minimumValueLabel: () -> LowerValueLabel,
        maximumValueLabel: () -> UpperValueLabel,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) {
        self._selection = selection
        self.range = range
        self.step = step
        self.minimumValueLabel = minimumValueLabel()
        self.maximumValueLabel = maximumValueLabel()
        self.onEditingChanged = onEditingChanged
    }

    private func offset(forWidth width: Double, at position: Index, isHandle: Bool = true) -> Double {
        let rangeWidth = range.upperBound - range.lowerBound
        let offset = if isHandle {
            ((position.value(in: selection) - range.lowerBound) / rangeWidth) * (width - sliderHandleSize)
        } else {
            switch position {
            case .lower:
                (
                    (position.value(in: selection) - range.lowerBound) / rangeWidth
                ) * (width - sliderHandleSize) + sliderHandleSize / 2
            case .upper:
                width - (
                    ((position.value(in: selection) - range.lowerBound) / rangeWidth) *
                    (width - sliderHandleSize) + sliderHandleSize / 2
                )
            }
        }
        return offset
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
                        offsets: (
                            offset(forWidth: geo.size.width, at: .lower, isHandle: false),
                            offset(forWidth: geo.size.width, at: .upper, isHandle: false)
                        )
                    )
                    HandleView(
                        offset: offset(forWidth: geo.size.width, at: .lower, isHandle: true)
                    )
                    .foregroundStyle(sliderHandleStyle.0)
                    .gesture(dragGesture(in: geo, at: .lower))
                    HandleView(
                        offset: offset(forWidth: geo.size.width, at: .upper, isHandle: true)
                    )
                    .foregroundStyle(sliderHandleStyle.1)
                    .gesture(dragGesture(in: geo, at: .upper))
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
        .customSensoryFeedback(value: selection, isEditing: isEditing, enabled: hapticFeedbackEnabled)
        .accessibilityValue(Text("\(selection.lowerBound) to \(selection.upperBound)"))
    }

    @State private var isEditing = false
    @State private var initialSelection: ClosedRange<Double>?

    private func dragGesture(in geometry: GeometryProxy, at index: Index) -> some Gesture {
        DragGesture()
            .onChanged { value in
                isEditing = true
                if initialSelection == nil {
                    initialSelection = selection
                }
                if let initialSelection {
                    let width = geometry.size.width - sliderHandleSize
                    var offset = (value.location.x - sliderHandleSize / 2) / width
                    if let step {
                        let normalizedStep = step / (range.upperBound - range.lowerBound)
                        offset = (offset / normalizedStep).rounded() * normalizedStep
                    }
                    self.selection = switch index {
                    case .lower:
                        max(
                            min(
                                offset * (
                                    range.upperBound - range.lowerBound
                                ) + range.lowerBound,
                                initialSelection.upperBound - (step ?? 0.0001)
                            ),
                            range.lowerBound
                        )...initialSelection.upperBound
                    case .upper:
                        initialSelection.lowerBound...max(
                            min(
                                offset * (
                                    range.upperBound - range.lowerBound
                                ) + range.lowerBound,
                                range.upperBound
                            ),
                            initialSelection.lowerBound + (step ?? 0.0001)
                        )
                    }
                }
            }
            .onEnded { _ in
                isEditing = false
                initialSelection = nil
            }
    }

    enum Index {
        case lower, upper

        func value(in range: ClosedRange<Double>) -> Double {
            switch self {
            case .lower:
                return range.lowerBound
            case .upper:
                return range.upperBound
            }
        }
    }
}
