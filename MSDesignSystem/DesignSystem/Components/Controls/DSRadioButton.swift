// DSRadioButton.swift
// DesignSystem/Components/Controls/DSRadioButton.swift
//
// Из Figma — MS Design System 2
// node-id: 482:7575
//
// Состояния: unchecked / checked × default / disabled
// Включает DSRadioGroup для групповой работы

import SwiftUI

// MARK: - DSRadioButton

struct DSRadioButton: View {

    // MARK: - Properties

    @Binding var isSelected: Bool
    var isDisabled: Bool = false
    var label: String? = nil
    var onChange: ((Bool) -> Void)? = nil

    // MARK: - Body

    var body: some View {
        Button(action: handleTap) {
            HStack(alignment: .center, spacing: DS.Spacing.s8) {
                radioBox
                if let label {
                    Text(label)
                        .dsFont(DS.Typography.paragraphSm)
                        .foregroundStyle(isDisabled ? DS.Color.textDisabled : DS.Color.textMain)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    // MARK: - Radio Box

    private var radioBox: some View {
        ZStack {
            // Outer circle 16×16 (inset 10% от 20×20 как в Figma)
            Circle()
                .fill(outerFill)
                .frame(width: 16, height: 16)

            // Inner shadow overlay (active-bg / disabled)
            if isSelected || isDisabled {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [innerShadowColor, .clear],
                            startPoint: .top,
                            endPoint: .center
                        )
                    )
                    .frame(width: 16, height: 16)
                    .allowsHitTesting(false)
            }

            // Outer border
            Circle()
                .strokeBorder(outerStroke, lineWidth: 1)
                .frame(width: 16, height: 16)

            // Белый круг-подложка (unchecked default) — inset 17.5% от 20 = 13×13
            if !isSelected && !isDisabled {
                Circle()
                    .fill(DS.Color.bgWhite)
                    .frame(width: 13, height: 13)
                    // Figma: radio-checkbox-shadow/default
                    .shadow(color: Color(hex: "#1B1C1D").opacity(0.12), radius: 2, x: 0, y: 2)
            }

            // Белая точка (checked) — inset 30% от 20 = 8×8
            if isSelected {
                Circle()
                    .fill(DS.Color.bgWhite)
                    .frame(width: 8, height: 8)
                    // Figma: radio-dot-active — drop shadow + inner bottom shadow (#CFD1D3)
                    .shadow(color: Color(hex: "#1B1C1D").opacity(0.12), radius: 2, x: 0, y: 2)
                    .overlay(
                        // Аппроксимация inner shadow снизу (#CFD1D3)
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.clear, Color(hex: "#CFD1D3").opacity(0.6)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blendMode(.multiply)
                            .clipShape(Circle())
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(DS.Color.bgWhite, lineWidth: 1)
                    )
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 20, height: 20)
        // Drop shadow только для unchecked default
        .shadow(color: outerDropShadow, radius: 2, x: 0, y: 2)
        .animation(DS.Animation.fast, value: isSelected)
    }

    // MARK: - Colors

    private var outerFill: Color {
        if isDisabled { return DS.Color.bgSurface }      // #E2E4E9
        if isSelected { return DS.Color.brandPrimary }   // #375DFB
        return DS.Color.bgSurface                        // #E2E4E9 (под белым кругом)
    }

    private var outerStroke: Color {
        if isDisabled { return DS.Color.textDisabled }       // #CDD0D5
        if isSelected { return DS.Color.brandPrimaryDark }   // #253EA7
        return .clear
    }

    // Drop shadow на outer circle только для unchecked default (через bgWeak frame)
    private var outerDropShadow: Color {
        guard !isSelected && !isDisabled else { return .clear }
        return Color(hex: "#1B1C1D").opacity(0.12)
    }

    // Figma: active-bg → rgba(22,38,100,0.32) | disabled → rgba(15,15,16,0.08)
    private var innerShadowColor: Color {
        if isDisabled { return Color(hex: "#0F0F10").opacity(0.08) }
        return Color(hex: "#162664").opacity(0.32)
    }

    // MARK: - Action

    private func handleTap() {
        guard !isDisabled, !isSelected else { return }
        isSelected = true
        onChange?(true)
    }
}

// MARK: - DSRadioGroup

/// Группа radio-кнопок — выбор одного из нескольких значений.
struct DSRadioGroup<T: Hashable>: View {

    struct Option {
        let value: T
        let label: String
        var isDisabled: Bool = false
    }

    @Binding var selection: T
    var options: [Option]
    var isDisabled: Bool = false   // глобальный disabled для всей группы
    var spacing: CGFloat = DS.Spacing.s12

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(options, id: \.value) { option in
                DSRadioButton(
                    isSelected: Binding(
                        get: { selection == option.value },
                        set: { if $0 { selection = option.value } }
                    ),
                    isDisabled: isDisabled || option.isDisabled,
                    label: option.label
                )
            }
        }
    }
}

// MARK: - Preview

private struct DSRadioButtonPreview: View {

    @State private var checked1 = false
    @State private var checked2 = true
    @State private var checked3 = false
    @State private var checked4 = true

    @State private var groupSel: String = "month"
    @State private var groupSel2: Int = 1

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                // Одиночные состояния
                sectionHeader("Default")
                HStack(spacing: DS.Spacing.s16) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSRadioButton(isSelected: $checked1)
                        Text("Unchecked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSRadioButton(isSelected: $checked2)
                        Text("Checked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                sectionHeader("Disabled")
                HStack(spacing: DS.Spacing.s16) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSRadioButton(isSelected: $checked3, isDisabled: true)
                        Text("Unchecked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSRadioButton(isSelected: $checked4, isDisabled: true)
                        Text("Checked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                // С подписью
                sectionHeader("С подписью")
                VStack(alignment: .leading, spacing: DS.Spacing.s12) {
                    DSRadioButton(isSelected: $checked1, label: "Вариант A")
                    DSRadioButton(isSelected: $checked2, label: "Вариант B")
                    DSRadioButton(isSelected: $checked3, isDisabled: true, label: "Недоступно")
                }

                // Группа — строки
                sectionHeader("DSRadioGroup — период")
                DSRadioGroup(
                    selection: $groupSel,
                    options: [
                        .init(value: "day",     label: "День"),
                        .init(value: "week",    label: "Неделя"),
                        .init(value: "month",   label: "Месяц"),
                        .init(value: "year",    label: "Год"),
                        .init(value: "forever", label: "Навсегда", isDisabled: true)
                    ]
                )

                // Группа — числа
                sectionHeader("DSRadioGroup — тариф")
                DSRadioGroup(
                    selection: $groupSel2,
                    options: [
                        .init(value: 1, label: "Free"),
                        .init(value: 2, label: "Pro"),
                        .init(value: 3, label: "Enterprise")
                    ]
                )

                Text("Выбрано: \(groupSel) / тариф \(groupSel2)")
                    .dsFont(DS.Typography.paragraphXS)
                    .foregroundStyle(DS.Color.textSoft)
            }
            .padding(DS.Spacing.s16)
        }
        .background(DS.Color.bgWeak)
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text.uppercased())
            .dsFont(DS.Typography.subheadingXS)
            .foregroundStyle(DS.Color.textSoft)
    }
}

#Preview("DSRadioButton — все состояния") {
    DSRadioButtonPreview()
}
