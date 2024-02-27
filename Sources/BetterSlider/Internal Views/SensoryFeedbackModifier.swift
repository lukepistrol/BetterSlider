//
//  SensoryFeedbackModifier.swift
//  BetterSlider
//
//  Created by Lukas Pistrol on 27.02.24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func customSensoryFeedback<Value: Equatable>(
        value: Value,
        isEditing: Bool,
        enabled: Bool
    ) -> some View {
        if !enabled {
            self
        } else if #available(iOS 17, *) {
            sensoryFeedback(trigger: value) { _, _ in
                if isEditing {
                    return .selection
                }
                return nil
            }
            .sensoryFeedback(.selection, trigger: isEditing)
        } else {
            self
                .onChange(of: value) { _ in
                    if isEditing {
                        UISelectionFeedbackGenerator().selectionChanged()
                    }
                }
                .onChange(of: isEditing) { _ in
                    UISelectionFeedbackGenerator().selectionChanged()
                }
        }
    }
}
