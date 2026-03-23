// DSCheckbox.swift
// DesignSystem/Components/Controls/DSCheckbox.swift
//
// Из Figma — MS Design System 2
// node-id: 480:7365
// Состояния: unchecked / checked / indeterminate × default / disabled

import SwiftUI

// MARK: - DSCheckbox

struct DSCheckbox: View {

    // MARK: - Properties

    /// Отмечен ли чекбокс (синий фон)
    @Binding var isChecked: Bool
    /// Неопределённое состояние — синий фон + тире вместо галочки
    var isIndeterminate: Bool = false
    /// Заблокирован
    var isDisabled: Bool = false
    /// Подпись справа от чекбокса
    var label: String? = nil
    /// Коллбэк при изменении (опционально)
    var onChange: ((Bool) -> Void)? = nil

    // MARK: - Body

    var body: some View {
        Button(action: handleTap) {
            HStack(alignment: .center, spacing: DS.Spacing.s8) {
                checkboxBox
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

    // MARK: - Box

    private var checkboxBox: some View {
        ZStack {
            // Основной прямоугольник 16×16 (inset 10% от 20×20 как в Figma)
            RoundedRectangle(cornerRadius: 4)
                .fill(fillColor)
                .frame(width: 16, height: 16)

            // Аппроксимация inner shadow для активных и disabled состояний
            if isActive || isDisabled {
                RoundedRectangle(cornerRadius: 4)
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

            // Граница
            RoundedRectangle(cornerRadius: 4)
                .strokeBorder(strokeColor, lineWidth: 1)
                .frame(width: 16, height: 16)

            // Галочка
            if isChecked && !isIndeterminate {
                DSCheckmarkShape()
                    .stroke(
                        checkmarkColor,
                        style: StrokeStyle(lineWidth: 1.5, lineCap: .round, lineJoin: .round)
                    )
                    .frame(width: 9, height: 7)
                    .transition(.scale.combined(with: .opacity))
            }

            // Тире (indeterminate)
            if isIndeterminate {
                RoundedRectangle(cornerRadius: 1)
                    .fill(checkmarkColor)
                    .frame(width: 8, height: 2)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .frame(width: 20, height: 20)
        // Drop shadow — только для unchecked default (Figma: radio-checkbox-shadow/default)
        .shadow(color: dropShadowColor, radius: 2, x: 0, y: 2)
        .animation(DS.Animation.fast, value: isChecked)
        .animation(DS.Animation.fast, value: isIndeterminate)
    }

    // MARK: - Computed Colors

    // isActive = синий фон (checked или indeterminate)
    private var isActive: Bool { isChecked || isIndeterminate }

    private var fillColor: Color {
        if isDisabled { return DS.Color.bgSurface }     // #E2E4E9
        if isActive   { return DS.Color.brandPrimary }  // #375DFB
        return DS.Color.bgWhite                         // unchecked: белый
    }

    private var strokeColor: Color {
        if isDisabled { return DS.Color.textDisabled }       // #CDD0D5
        if isActive   { return DS.Color.brandPrimaryDark }   // #253EA7
        return DS.Color.strokeSoft                           // unchecked: #E2E4E9
    }

    // Figma: radio-checkbox-shadow/default — drop shadow только для unchecked
    private var dropShadowColor: Color {
        guard !isActive && !isDisabled else { return .clear }
        return Color(hex: "#1B1C1D").opacity(0.12)
    }

    // Figma: radio-checkbox-shadow/active-bg или /disabled
    private var innerShadowColor: Color {
        if isDisabled { return Color(hex: "#0F0F10").opacity(0.08) }
        return Color(hex: "#162664").opacity(0.32)
    }

    private var checkmarkColor: Color {
        isDisabled ? DS.Color.textDisabled : DS.Color.textWhite
    }

    // MARK: - Action

    private func handleTap() {
        guard !isDisabled else { return }
        isChecked.toggle()
        onChange?(isChecked)
    }
}

// MARK: - Checkmark Shape

private struct DSCheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        // Три точки классической галочки
        path.move(to: CGPoint(x: 0, y: rect.height * 0.5))
        path.addLine(to: CGPoint(x: rect.width * 0.33, y: rect.height))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// MARK: - Preview

private struct DSCheckboxPreview: View {

    @State private var checked1 = false
    @State private var checked2 = true
    @State private var checked3 = false
    @State private var checked4 = false
    @State private var checked5 = true
    @State private var checked6 = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                // Default states
                sectionHeader("Default")

                HStack(spacing: DS.Spacing.s16) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked1)
                        Text("Unchecked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked2)
                        Text("Checked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked3, isIndeterminate: true)
                        Text("Indeterminate").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                // Disabled states
                sectionHeader("Disabled")

                HStack(spacing: DS.Spacing.s16) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked4, isDisabled: true)
                        Text("Unchecked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked5, isDisabled: true)
                        Text("Checked").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSCheckbox(isChecked: $checked6, isIndeterminate: true, isDisabled: true)
                        Text("Indeterminate").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                // With label
                sectionHeader("С подписью")

                VStack(alignment: .leading, spacing: DS.Spacing.s12) {
                    DSCheckbox(isChecked: $checked1, label: "Я принимаю условия использования")
                    DSCheckbox(isChecked: $checked2, label: "Подписаться на рассылку")
                    DSCheckbox(isChecked: $checked3, isIndeterminate: true, label: "Выбрать всё")
                    DSCheckbox(isChecked: $checked4, isDisabled: true, label: "Недоступный пункт")
                }

                // Interactive demo
                sectionHeader("Интерактив")

                VStack(alignment: .leading, spacing: DS.Spacing.s8) {
                    DSCheckbox(
                        isChecked: $checked1,
                        label: "Нажми на меня",
                        onChange: { _ in }
                    )
                    Text(checked1 ? "✓ Отмечено" : "○ Не отмечено")
                        .dsFont(DS.Typography.paragraphXS)
                        .foregroundStyle(checked1 ? DS.Color.success : DS.Color.textSoft)
                        .animation(DS.Animation.fast, value: checked1)
                }
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

#Preview("DSCheckbox — все состояния") {
    DSCheckboxPreview()
}
