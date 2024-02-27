//
//  EnvironmentValues.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 26.02.24.
//

import SwiftUI

// MARK: Show Slider Step

struct ShowSliderStep: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var showSliderStep: Bool {
        get { self[ShowSliderStep.self] }
        set { self[ShowSliderStep.self] = newValue }
    }
}

public extension View {
    /// Show step markers on the slider's track.
    ///
    /// - Parameter enabled: A boolean value that indicates whether to show step markers on the slider.
    ///
    /// > Important: Only has an effect if the `step` parameter is set in the ``BetterSlider/BetterSlider``
    /// > or ``BetterSlider/RangeSlider`` initializer.
    func showSliderStep(_ enabled: Bool = true) -> some View {
        environment(\.showSliderStep, enabled)
    }
}

// MARK: Track Height

struct SliderTrackHeightKey: EnvironmentKey {
    static let defaultValue: Double = 4
}

extension EnvironmentValues {
    var sliderTrackHeight: Double {
        get { self[SliderTrackHeightKey.self] }
        set { self[SliderTrackHeightKey.self] = newValue }
    }
}

public extension View {
    /// Set the height of the slider's track.
    ///
    /// - Parameter height: The height of the slider's track. The default value is `4`.
    func sliderTrackHeight(_ height: Double) -> some View {
        environment(\.sliderTrackHeight, height)
    }
}

// MARK: Handle Size

struct SliderHandleSize: EnvironmentKey {
    static let defaultValue: Double = 28
}

extension EnvironmentValues {
    var sliderHandleSize: Double {
        get { self[SliderHandleSize.self] }
        set { self[SliderHandleSize.self] = newValue }
    }
}

public extension View {
    /// Set the size of the slider's handle.
    ///
    /// - Parameter size: The size of the slider's handle. The default value is `28`.
    func sliderHandleSize(_ size: Double) -> some View {
        environment(\.sliderHandleSize, size)
    }
}

// MARK: Handle Color

struct SliderHandleColor: EnvironmentKey {
    static let defaultValue: (Color, Color) = (.white, .white)
}

extension EnvironmentValues {
    var sliderHandleColor: (Color, Color) {
        get { self[SliderHandleColor.self] }
        set { self[SliderHandleColor.self] = newValue }
    }
}

public extension View {
    /// Set the color of the slider's handle.
    ///
    /// - Parameter color: The color of the slider's handle. The default value is `Color.white`.
    ///
    /// > Important: If you want to set different colors for the lower and upper handles of 
    /// > a ``BetterSlider/RangeSlider``, use the ``SwiftUI/View/sliderHandleColor(lower:upper:)`` method.
    func sliderHandleColor(_ color: Color) -> some View {
        environment(\.sliderHandleColor, (color, color))
    }

    /// Set the color of the slider's handles.
    ///
    /// - Parameters:
    ///   - lower: The color of the lower handle.
    ///   - upper: The color of the upper handle.
    ///
    /// > Important: Only has an effect if the slider is a ``BetterSlider/RangeSlider``.
    /// > Otherwise the `lower` color will be used for the single handle.
    func sliderHandleColor(lower: Color, upper: Color) -> some View {
        environment(\.sliderHandleColor, (lower, upper))
    }
}

// MARK: Track Color

struct SliderTrackColor: EnvironmentKey {
    static let defaultValue: Color = Color(uiColor: .init(dynamicProvider: { traits in
        switch traits.userInterfaceStyle {
        case .dark: UIColor(red: 61.0/255, green: 61.0/255, blue: 65.0/255, alpha: 1)
        default: UIColor(red: 228.0/255, green: 228.0/255, blue: 230.0/255, alpha: 1)
        }
    }))
}

extension EnvironmentValues {
    var sliderTrackColor: Color {
        get { self[SliderTrackColor.self] }
        set { self[SliderTrackColor.self] = newValue }
    }
}

public extension View {
    /// Set the color of the slider's track.
    ///
    /// - Parameter color: The color of the slider's track. The default color is the same
    /// used by the system's `Slider`.
    func sliderTrackColor(_ color: Color) -> some View {
        environment(\.sliderTrackColor, color)
    }
}

// MARK: Step Height

struct SliderStepHeight: EnvironmentKey {
    static let defaultValue: Double? = nil
}

extension EnvironmentValues {
    var sliderStepHeight: Double? {
        get { self[SliderStepHeight.self] }
        set { self[SliderStepHeight.self] = newValue }
    }
}

public extension View {
    /// Set the height of the slider's step markers.
    ///
    /// - Parameter size: The height of the slider's step markers. By default the height is 80% of the handle size.
    ///
    /// > Important: Only has an effect if the `step` parameter is set in the ``BetterSlider/BetterSlider``
    /// > or ``BetterSlider/RangeSlider`` initializer.
    func sliderStepHeight(_ size: Double) -> some View {
        environment(\.sliderStepHeight, size)
    }
}

// MARK: Haptic Feedback

struct HapticFeedbackEnabled: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    var hapticFeedbackEnabled: Bool {
        get { self[HapticFeedbackEnabled.self] }
        set { self[HapticFeedbackEnabled.self] = newValue }
    }
}

public extension View {
    /// Enable haptic feedback for the slider.
    ///
    /// - Parameter enabled: A boolean value that indicates whether to enable haptic feedback.
    func hapticFeedback(_ enabled: Bool = true) -> some View {
        environment(\.hapticFeedbackEnabled, enabled)
    }
}
