// DSToggle.swift
// DesignSystem/Components/Controls/DSToggle.swift
//
// Из Figma — MS Design System 2
// node-id: 464:8344
// Состояния: off / on × default / disabled

import SwiftUI

// MARK: - DSToggle

struct DSToggle: View {

    // MARK: - Properties

    @Binding var isOn: Bool
    var isDisabled: Bool = false
    var label: String? = nil
    var onChange: ((Bool) -> Void)? = nil

    // MARK: - Body

    var body: some View {
        Button(action: handleTap) {
            HStack(alignment: .center, spacing: DS.Spacing.s8) {
                if let label {
                    Text(label)
                        .dsFont(DS.Typography.paragraphSm)
                        .foregroundStyle(isDisabled ? DS.Color.textDisabled : DS.Color.textMain)
                    Spacer()
                }
                toggleTrack
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    // MARK: - Track + Thumb

    private var toggleTrack: some View {
        ZStack {
            // Track: 28×16 pill (inset 10% v, 6.25% h от 32×20)
            Capsule()
                .fill(trackFill)
                .overlay(
                    // Inner shadow top — аппроксимация
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [trackInnerShadow, .clear],
                                startPoint: .top,
                                endPoint: .center
                            )
                        )
                )
                .overlay(
                    Capsule()
                        .strokeBorder(trackStroke, lineWidth: 1)
                )
                .frame(width: 28, height: 16)

            // Thumb: 12×12, смещается ±6 от центра
            Circle()
                .fill(thumbFill)
                .frame(width: 12, height: 12)
                .overlay(
                    // Inner shadow снизу (#E4E5E7) — придаёт 3D объём
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.clear, thumbInnerShadow],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blendMode(.multiply)
                )
                .overlay(Circle().strokeBorder(DS.Color.bgWhite.opacity(0.6), lineWidth: 0.5))
                .shadow(color: thumbShadow1, radius: 10, x: 0, y: 6)
                .shadow(color: thumbShadow2, radius: 4,  x: 0, y: 2)
                .offset(x: isOn ? 6 : -6)
                .animation(DS.Animation.standard, value: isOn)
        }
        .frame(width: 32, height: 20)
        .animation(DS.Animation.standard, value: isOn)
    }

    // MARK: - Colors

    private var trackFill: Color {
        if isDisabled { return DS.Color.bgWhite }
        return isOn ? DS.Color.brandPrimary : DS.Color.bgSurface  // #375DFB / #E2E4E9
    }

    private var trackStroke: Color {
        if isDisabled { return DS.Color.bgSurface }               // #E2E4E9
        return isOn ? DS.Color.brandPrimaryDark : DS.Color.textDisabled  // #253EA7 / #CDD0D5
    }

    // Figma: toggle-shadow/active-bg (0.12) / default-bg (0.06)
    private var trackInnerShadow: Color {
        if isDisabled { return .clear }
        return Color(hex: "#0F0F10").opacity(isOn ? 0.12 : 0.06)
    }

    private var thumbFill: Color {
        isDisabled ? DS.Color.bgSurface : DS.Color.bgWhite
    }

    // Figma: toggle-shadow/active rgba(22,38,100,0.08) / default rgba(27,28,29,0.06)
    private var thumbShadow1: Color {
        guard !isDisabled else { return .clear }
        return isOn
            ? Color(hex: "#162664").opacity(0.08)
            : Color(hex: "#1B1C1D").opacity(0.06)
    }

    private var thumbShadow2: Color {
        guard !isDisabled else { return .clear }
        return isOn
            ? Color(hex: "#162664").opacity(0.08)
            : Color(hex: "#1B1C1D").opacity(0.02)
    }

    // Figma: inner shadow bottom на thumb — #E4E5E7
    private var thumbInnerShadow: Color {
        isOn
            ? Color(hex: "#E4E5E7").opacity(1.0)
            : Color(hex: "#E4E5E7").opacity(0.48)
    }

    // MARK: - Action

    private func handleTap() {
        guard !isDisabled else { return }
        isOn.toggle()
        onChange?(isOn)
    }
}

// MARK: - Preview

private struct DSTogglePreview: View {

    @State private var t1 = false
    @State private var t2 = true
    @State private var t3 = false
    @State private var t4 = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                sectionHeader("Default")
                HStack(spacing: DS.Spacing.s24) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSToggle(isOn: $t1)
                        Text("Off").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSToggle(isOn: $t2)
                        Text("On").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                sectionHeader("Disabled")
                HStack(spacing: DS.Spacing.s24) {
                    VStack(spacing: DS.Spacing.s4) {
                        DSToggle(isOn: $t3, isDisabled: true)
                        Text("Off").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    VStack(spacing: DS.Spacing.s4) {
                        DSToggle(isOn: $t4, isDisabled: true)
                        Text("On").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                }

                sectionHeader("С подписью")
                VStack(spacing: DS.Spacing.s12) {
                    DSToggle(isOn: $t1, label: "Тёмная тема")
                    DSToggle(isOn: $t2, label: "Push-уведомления")
                    DSToggle(isOn: $t3, isDisabled: true, label: "Недоступная настройка")
                }
                .padding(DS.Spacing.s16)
                .background(DS.Color.bgWhite)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
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

#Preview("DSToggle — все состояния") {
    DSTogglePreview()
}
