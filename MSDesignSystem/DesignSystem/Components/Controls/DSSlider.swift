// DSSlider.swift
// DesignSystem/Components/Controls/DSSlider.swift
//
// Из Figma — MS Design System 2
// node-id: 5070-14621
// Track: 6pt, bgSurface → brandPrimary fill
// Thumb: 16×16 white circle + shadow + 5pt inner dot
// Optional: label row (label + sublabel + value), tooltip above thumb

import SwiftUI

// MARK: - DSSlider

struct DSSlider: View {

    // MARK: - Properties

    @Binding var value: Double
    var range: ClosedRange<Double> = 0...1
    var step: Double? = nil
    var label: String? = nil
    var sublabel: String? = nil
    /// Форматированное значение в правом углу (если nil — не показывается)
    var valueLabel: String? = nil
    /// Показывать тултип над ползунком
    var showTooltip: Bool = false
    /// Форматтер для тултипа (по умолчанию — целое число %)
    var tooltipFormatter: ((Double) -> String)? = nil
    var isDisabled: Bool = false

    // MARK: - Private

    private let trackHeight: CGFloat = 6
    private let thumbSize: CGFloat = 16
    private let innerDotSize: CGFloat = 5

    @State private var isDragging: Bool = false

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            // Label row
            if label != nil || sublabel != nil || valueLabel != nil {
                labelRow
            }

            // Slider track + thumb
            GeometryReader { geo in
                let trackWidth = geo.size.width
                let thumbOffset = thumbX(trackWidth: trackWidth)

                ZStack(alignment: .leading) {
                    // Track background
                    Capsule()
                        .fill(DS.Color.bgSurface)
                        .frame(height: trackHeight)

                    // Track fill
                    Capsule()
                        .fill(isDisabled ? DS.Color.textDisabled : DS.Color.brandPrimary)
                        .frame(width: max(thumbOffset + thumbSize / 2, 0), height: trackHeight)

                    // Thumb
                    ZStack {
                        // Tooltip
                        if showTooltip && isDragging {
                            tooltipView
                                .offset(y: -28)
                                .transition(.opacity.combined(with: .scale(scale: 0.9, anchor: .bottom)))
                        }

                        // Thumb circle
                        Circle()
                            .fill(DS.Color.bgWhite)
                            .frame(width: thumbSize, height: thumbSize)
                            .shadow(color: Color(hex: "#0A0D14").opacity(0.12), radius: 4, x: 0, y: 2)
                            .shadow(color: Color(hex: "#0A0D14").opacity(0.08), radius: 1, x: 0, y: 1)
                            .overlay(
                                Circle()
                                    .fill(innerDotColor)
                                    .frame(width: innerDotSize, height: innerDotSize)
                            )
                    }
                    .frame(width: thumbSize, height: thumbSize)
                    .offset(x: thumbOffset)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { drag in
                                isDragging = true
                                updateValue(dragX: drag.location.x, trackWidth: trackWidth)
                            }
                            .onEnded { _ in
                                withAnimation(DS.Animation.fast) { isDragging = false }
                            }
                    )
                    .animation(DS.Animation.standard, value: value)
                }
                .frame(height: thumbSize)
                .contentShape(Rectangle())
                .onTapGesture { location in
                    updateValue(dragX: location.x, trackWidth: trackWidth)
                }
            }
            .frame(height: thumbSize)
            .disabled(isDisabled)
            .opacity(isDisabled ? 0.5 : 1)
        }
        .animation(DS.Animation.fast, value: isDragging)
    }

    // MARK: - Label Row

    private var labelRow: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 0) {
                if let label {
                    Text(label)
                        .dsFont(DS.Typography.labelSm)
                        .foregroundStyle(DS.Color.textMain)
                }
                if let sublabel {
                    Text(sublabel)
                        .dsFont(DS.Typography.paragraphXS)
                        .foregroundStyle(DS.Color.textSoft)
                }
            }
            Spacer()
            if let valueLabel {
                Text(valueLabel)
                    .dsFont(DS.Typography.paragraphXS)
                    .foregroundStyle(DS.Color.textSoft)
                    .monospacedDigit()
            }
        }
    }

    // MARK: - Tooltip

    private var tooltipView: some View {
        let formatted = tooltipFormatter?(value) ?? defaultFormat(value)
        return Text(formatted)
            .dsFont(DS.Typography.paragraphXS)
            .foregroundStyle(DS.Color.textWhite)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(DS.Color.neutralBase)
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    // MARK: - Helpers

    private var innerDotColor: Color {
        let normalized = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return normalized <= 0.001
            ? DS.Color.textSoft
            : DS.Color.brandPrimary
    }

    private func thumbX(trackWidth: CGFloat) -> CGFloat {
        let normalized = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        let usable = trackWidth - thumbSize
        return normalized * usable
    }

    private func updateValue(dragX: CGFloat, trackWidth: CGFloat) {
        let usable = trackWidth - thumbSize
        let clamped = min(max(dragX - thumbSize / 2, 0), usable)
        let normalized = clamped / usable
        var newValue = range.lowerBound + normalized * (range.upperBound - range.lowerBound)

        if let step {
            newValue = (newValue / step).rounded() * step
        }
        newValue = min(max(newValue, range.lowerBound), range.upperBound)
        value = newValue
    }

    private func defaultFormat(_ v: Double) -> String {
        let span = range.upperBound - range.lowerBound
        if span <= 1 {
            return "\(Int(v * 100))%"
        } else {
            return "\(Int(v))"
        }
    }
}

// MARK: - Preview

#Preview("DSSlider — все варианты") {
    struct PreviewWrapper: View {
        @State private var v1: Double = 0.4
        @State private var v2: Double = 60
        @State private var v3: Double = 0.0
        @State private var v4: Double = 1.0
        @State private var v5: Double = 0.65

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s32) {

                    sectionHeader("Простой слайдер")
                    DSSlider(value: $v1)

                    sectionHeader("С лейблом и значением")
                    DSSlider(
                        value: $v2,
                        range: 0...100,
                        step: 5,
                        label: "Громкость",
                        sublabel: "Системная",
                        valueLabel: "\(Int(v2))%",
                        showTooltip: true,
                        tooltipFormatter: { "\(Int($0))%" }
                    )

                    sectionHeader("Начало диапазона (0%)")
                    DSSlider(value: $v3, label: "Прозрачность")

                    sectionHeader("Конец диапазона (100%)")
                    DSSlider(value: $v4, label: "Яркость")

                    sectionHeader("С тултипом")
                    DSSlider(
                        value: $v5,
                        label: "Кэшбэк",
                        valueLabel: "\(Int(v5 * 100))%",
                        showTooltip: true
                    )

                    sectionHeader("Disabled")
                    DSSlider(
                        value: .constant(0.3),
                        label: "Недоступно",
                        isDisabled: true
                    )

                    sectionHeader("Денежный диапазон (0–50 000)")
                    DSSlider(
                        value: $v2,
                        range: 0...50000,
                        step: 1000,
                        label: "Сумма перевода",
                        valueLabel: "\(Int(v2)) ₽",
                        showTooltip: true,
                        tooltipFormatter: { "\(Int($0)) ₽" }
                    )
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
