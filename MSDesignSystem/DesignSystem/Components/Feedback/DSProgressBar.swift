// DSProgressBar.swift
// DesignSystem/Components/Feedback/DSProgressBar.swift
//
// Из Figma — MS Design System 2
// node-id: 4899:14826
// Высота 6pt, track #E2E4E9, fill brandPrimary, radius full

import SwiftUI

// MARK: - DSProgressBar

struct DSProgressBar: View {

    // MARK: - Properties

    /// Прогресс от 0.0 до 1.0
    var progress: Double
    /// Цвет заливки (по умолчанию brandPrimary)
    var color: Color = DS.Color.brandPrimary
    /// Высота полосы (по умолчанию 6pt из Figma)
    var height: CGFloat = 6
    /// Анимировать изменение прогресса
    var animated: Bool = true

    // MARK: - Body

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                // Track
                Capsule()
                    .fill(DS.Color.bgSurface)   // #E2E4E9

                // Fill
                Capsule()
                    .fill(color)
                    .frame(width: fillWidth(total: geo.size.width))
            }
        }
        .frame(height: height)
        .animation(animated ? DS.Animation.standard : nil, value: progress)
    }

    private func fillWidth(total: CGFloat) -> CGFloat {
        total * min(max(progress, 0), 1)
    }
}

// MARK: - DSStepProgressBar (шаги)

/// Прогресс по шагам — N сегментов, заполненных до currentStep
struct DSStepProgressBar: View {

    var totalSteps: Int
    var currentStep: Int
    var color: Color = DS.Color.brandPrimary
    var height: CGFloat = 6
    var spacing: CGFloat = DS.Spacing.xs

    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Capsule()
                    .fill(step < currentStep ? color : DS.Color.bgSurface)
                    .frame(height: height)
                    .animation(DS.Animation.standard, value: currentStep)
            }
        }
    }
}

// MARK: - Preview

#Preview("DSProgressBar — все варианты") {
    struct PreviewWrapper: View {
        @State private var progress: Double = 0.4
        @State private var step = 2

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                    sectionHeader("Статичные значения")
                    VStack(spacing: DS.Spacing.s12) {
                        ForEach([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0], id: \.self) { val in
                            HStack {
                                Text("\(Int(val * 100))%")
                                    .dsFont(DS.Typography.paragraphXS)
                                    .foregroundStyle(DS.Color.textSoft)
                                    .frame(width: 32, alignment: .trailing)
                                DSProgressBar(progress: val)
                            }
                        }
                    }

                    sectionHeader("Разные цвета")
                    DSProgressBar(progress: 0.6, color: DS.Color.brandPrimary)
                    DSProgressBar(progress: 0.6, color: DS.Color.success)
                    DSProgressBar(progress: 0.6, color: DS.Color.error)
                    DSProgressBar(progress: 0.6, color: DS.Color.warning)

                    sectionHeader("Интерактивный")
                    DSProgressBar(progress: progress)
                    HStack {
                        Text("\(Int(progress * 100))%")
                            .dsFont(DS.Typography.labelSm)
                            .foregroundStyle(DS.Color.textMain)
                            .frame(width: 40)
                        Slider(value: $progress, in: 0...1)
                            .tint(DS.Color.brandPrimary)
                    }

                    sectionHeader("DSStepProgressBar (шаги)")
                    DSStepProgressBar(totalSteps: 4, currentStep: step)
                    HStack(spacing: DS.Spacing.s8) {
                        DSButton("−", type: .neutral, style: .stroke, size: .small) {
                            if step > 0 { step -= 1 }
                        }
                        Text("Шаг \(step) из 4")
                            .dsFont(DS.Typography.paragraphSm)
                            .foregroundStyle(DS.Color.textMain)
                        DSButton("+", size: .small) {
                            if step < 4 { step += 1 }
                        }
                    }

                    sectionHeader("Разные высоты")
                    DSProgressBar(progress: 0.6, height: 4)
                    DSProgressBar(progress: 0.6, height: 6)
                    DSProgressBar(progress: 0.6, height: 8)
                    DSProgressBar(progress: 0.6, height: 12)
                }
                .padding(DS.Spacing.s16)
            }
            .background(DS.Color.bgWeak)
        }
    }
    return PreviewWrapper()
}

private func sectionHeader(_ text: String) -> some View {
    Text(text.uppercased())
        .dsFont(DS.Typography.subheadingXS)
        .foregroundStyle(DS.Color.textSoft)
}
