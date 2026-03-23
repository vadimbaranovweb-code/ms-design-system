// DSBadge.swift
// DesignSystem/Components/Badges/DSBadge.swift
//
// Сгенерировано из Figma — MS Design System 2
// node-id: 414:12702  Badge [1.0]
// Поддерживает: Type × Style × Color × Number × Disabled

import SwiftUI

// MARK: - DSBadge

struct DSBadge: View {

    // MARK: - Types

    enum BadgeType {
        case basic               // Только текст
        case withDot             // ⊚ Точка-статус + текст
        case leftIcon(String)    // ⬅️ SF Symbol + текст
        case rightIcon(String)   // ➡️ Текст + SF Symbol
        case number(Int)         // Круглый числовой бейдж
    }

    enum BadgeStyle {
        case light   // Светлый тинт фона (Light в Figma)
        case filled  // Заливка BASE цветом, белый текст
        case stroke  // Белый фон + цветной бордер
    }

    enum BadgeColor {
        case blue    // 💙 Primary
        case orange  // 🧡 Warning
        case red     // 💔 Error
        case yellow  // 💛 Yellow
        case green   // 💚 Success
        case purple  // 💜 Secondary
        case pink    // 🩷 Pink
        case teal    // 🩵 Teal / Info
        case gray    // 🩶 Neutral
    }

    // MARK: - Properties

    var label: String
    var type: BadgeType = .basic
    var style: BadgeStyle = .light
    var color: BadgeColor = .gray
    var isDisabled: Bool = false

    // MARK: - Body

    var body: some View {
        switch type {
        case .number(let n):
            numberBadge(n)
        default:
            textBadge
        }
    }

    // MARK: - Text Badge

    private var textBadge: some View {
        HStack(spacing: 4) {
            // Dot
            if case .withDot = type {
                Circle()
                    .fill(isDisabled ? DS.Color.textDisabled : foregroundColor)
                    .frame(width: 6, height: 6)
            }

            // Left Icon
            if case .leftIcon(let icon) = type {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
            }

            // Label
            Text(label)
                .dsFont(DS.Typography.labelXS)  // 12pt medium
                .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
                .lineLimit(1)

            // Right Icon
            if case .rightIcon(let icon) = type {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
            }
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
        .background(backgroundColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(
                    isDisabled ? DS.Color.strokeSoft : borderColor,
                    lineWidth: style == .stroke ? 1 : 0
                )
        )
    }

    // MARK: - Number Badge (круглый)

    private func numberBadge(_ n: Int) -> some View {
        Text(n > 99 ? "99+" : "\(n)")
            .dsFont(DS.Typography.labelXS)
            .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
            .lineLimit(1)
            .padding(.horizontal, n > 9 ? 5 : 0)
            .frame(minWidth: 20, minHeight: 20)
            .background(backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .strokeBorder(
                        isDisabled ? DS.Color.strokeSoft : borderColor,
                        lineWidth: style == .stroke ? 1 : 0
                    )
            )
    }

    // MARK: - Цвета из Figma

    // BASE цвет — используется в Filled фоне, Stroke бордере, Light тексте
    private var baseColor: SwiftUI.Color {
        switch color {
        case .blue:   return DS.Color.brandPrimary      // #375DFB
        case .orange: return DS.Color.warning           // #F17B2C
        case .red:    return DS.Color.error             // #DF1C41
        case .yellow: return DS.Primitive.Yellow.base   // #F2AE40
        case .green:  return DS.Color.success           // #38C793
        case .purple: return DS.Color.brandSecondary    // #6E3FF3
        case .pink:   return DS.Primitive.Pink.base     // #E255F2
        case .teal:   return DS.Color.info              // #35B9E9
        case .gray:   return DS.Color.neutralBase       // #20232D
        }
    }

    // DARK цвет — для текста/иконок в Light и Stroke стиле
    private var darkColor: SwiftUI.Color {
        switch color {
        case .blue:   return DS.Color.brandPrimaryDark          // #253EA7
        case .orange: return DS.Color.warningDark               // #C2540A
        case .red:    return DS.Color.errorDark                 // #AF1D38
        case .yellow: return DS.Primitive.Yellow.dark           // #B47818
        case .green:  return DS.Color.successDark               // #2D9F75
        case .purple: return DS.Color.brandSecondaryDark        // #5A36BF
        case .pink:   return DS.Primitive.Pink.dark             // #9C23A9
        case .teal:   return DS.Primitive.Teal.dark             // #1F87AD
        case .gray:   return DS.Color.textSub                   // #525866
        }
    }

    // LIGHTER тинт — для Light фона
    private var lighterColor: SwiftUI.Color {
        switch color {
        case .blue:   return DS.Color.brandPrimaryLighter    // #EBF1FF
        case .orange: return DS.Color.warningLighter         // #FEF3EB
        case .red:    return DS.Color.errorLighter           // #FDEDF0
        case .yellow: return DS.Primitive.Yellow.lighter     // #FEF7EC
        case .green:  return DS.Color.successLighter         // #EFFAF6
        case .purple: return DS.Color.brandSecondaryLighter  // #EEEBFF
        case .pink:   return DS.Primitive.Pink.lighter       // #FDEBFF
        case .teal:   return DS.Color.infoLighter            // #EBFAFF
        case .gray:   return DS.Color.bgWeak                 // #F6F8FA
        }
    }

    // Фон бейджа
    private var backgroundColor: SwiftUI.Color {
        if isDisabled {
            return style == .filled ? DS.Color.bgSurface : DS.Color.bgWeak
        }
        switch style {
        case .light:  return lighterColor
        case .filled: return baseColor
        case .stroke: return DS.Color.bgWhite
        }
    }

    // Цвет текста / иконок / точки
    private var foregroundColor: SwiftUI.Color {
        switch style {
        case .light, .stroke: return darkColor
        case .filled:         return DS.Color.textWhite  // Белый на заливке
        }
    }

    // Цвет бордера (только для Stroke)
    private var borderColor: SwiftUI.Color {
        switch color {
        case .gray: return DS.Color.strokeSoft  // У серого мягкий бордер
        default:    return baseColor
        }
    }
}

// MARK: - Convenience Inits

extension DSBadge {

    // Простой текстовый бейдж
    init(
        _ label: String,
        color: BadgeColor = .gray,
        style: BadgeStyle = .light
    ) {
        self.label = label
        self.color = color
        self.style = style
    }

    // С иконкой
    init(
        _ label: String,
        leftIcon: String,
        color: BadgeColor = .gray,
        style: BadgeStyle = .light
    ) {
        self.label = label
        self.type = .leftIcon(leftIcon)
        self.color = color
        self.style = style
    }

    init(
        _ label: String,
        rightIcon: String,
        color: BadgeColor = .gray,
        style: BadgeStyle = .light
    ) {
        self.label = label
        self.type = .rightIcon(rightIcon)
        self.color = color
        self.style = style
    }

    // С точкой-статусом
    init(
        _ label: String,
        dot: Bool,
        color: BadgeColor = .gray,
        style: BadgeStyle = .light
    ) {
        self.label = label
        self.type = dot ? .withDot : .basic
        self.color = color
        self.style = style
    }

    // Числовой
    init(
        number: Int,
        color: BadgeColor = .red,
        style: BadgeStyle = .filled
    ) {
        self.label = ""
        self.type = .number(number)
        self.color = color
        self.style = style
    }
}

// MARK: - Preview

#Preview("DSBadge — все варианты") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.s20) {

            // LIGHT (дефолт)
            sectionHeader("Light")
            FlowLayout(spacing: DS.Spacing.s8) {
                DSBadge("Blue",   color: .blue)
                DSBadge("Orange", color: .orange)
                DSBadge("Red",    color: .red)
                DSBadge("Yellow", color: .yellow)
                DSBadge("Green",  color: .green)
                DSBadge("Purple", color: .purple)
                DSBadge("Pink",   color: .pink)
                DSBadge("Teal",   color: .teal)
                DSBadge("Gray",   color: .gray)
            }

            // FILLED
            sectionHeader("Filled")
            FlowLayout(spacing: DS.Spacing.s8) {
                DSBadge("Blue",   color: .blue,   style: .filled)
                DSBadge("Orange", color: .orange, style: .filled)
                DSBadge("Red",    color: .red,    style: .filled)
                DSBadge("Yellow", color: .yellow, style: .filled)
                DSBadge("Green",  color: .green,  style: .filled)
                DSBadge("Purple", color: .purple, style: .filled)
                DSBadge("Pink",   color: .pink,   style: .filled)
                DSBadge("Teal",   color: .teal,   style: .filled)
                DSBadge("Gray",   color: .gray,   style: .filled)
            }

            // STROKE
            sectionHeader("Stroke")
            FlowLayout(spacing: DS.Spacing.s8) {
                DSBadge("Blue",   color: .blue,   style: .stroke)
                DSBadge("Orange", color: .orange, style: .stroke)
                DSBadge("Red",    color: .red,    style: .stroke)
                DSBadge("Yellow", color: .yellow, style: .stroke)
                DSBadge("Green",  color: .green,  style: .stroke)
                DSBadge("Purple", color: .purple, style: .stroke)
                DSBadge("Pink",   color: .pink,   style: .stroke)
                DSBadge("Teal",   color: .teal,   style: .stroke)
                DSBadge("Gray",   color: .gray,   style: .stroke)
            }

            // TYPES
            sectionHeader("Types × Colors")
            FlowLayout(spacing: DS.Spacing.s8) {
                // Basic
                DSBadge("Badge", color: .blue)
                // With Dot
                DSBadge("Online",  dot: true, color: .green)
                DSBadge("Pending", dot: true, color: .orange)
                DSBadge("Offline", dot: true, color: .gray)
                // Left Icon
                DSBadge("New",      leftIcon: "sparkles",       color: .purple)
                DSBadge("Verified", leftIcon: "checkmark.seal.fill", color: .green)
                DSBadge("Warning",  leftIcon: "exclamationmark.triangle.fill", color: .yellow)
                // Right Icon
                DSBadge("Expand",  rightIcon: "chevron.down",  color: .blue)
                DSBadge("Premium", rightIcon: "arrow.right",   color: .purple, style: .filled)
            }

            // NUMBER BADGES
            sectionHeader("Number")
            HStack(spacing: DS.Spacing.s8) {
                DSBadge(number: 1)
                DSBadge(number: 5,  color: .orange)
                DSBadge(number: 12, color: .red)
                DSBadge(number: 99, color: .purple)
                DSBadge(number: 100, color: .blue)
                DSBadge(number: 3,  color: .green,  style: .light)
                DSBadge(number: 7,  color: .blue,   style: .stroke)
            }

            // DISABLED
            sectionHeader("Disabled")
            FlowLayout(spacing: DS.Spacing.s8) {
                DSBadge("Light disabled").withDisabled(true)
                DSBadge("Filled disabled", color: .blue, style: .filled).withDisabled(true)
                DSBadge("Stroke disabled", color: .blue, style: .stroke).withDisabled(true)
                DSBadge("Dot disabled", dot: true, color: .green).withDisabled(true)
                DSBadge(number: 5).withDisabled(true)
            }
        }
        .padding(DS.Spacing.s16)
    }
    .background(DS.Color.bgWeak)
}

// MARK: - Helper modifier

extension DSBadge {
    func withDisabled(_ disabled: Bool) -> DSBadge {
        var copy = self
        copy.isDisabled = disabled
        return copy
    }
}

// MARK: - Preview Helpers

private func sectionHeader(_ title: String) -> some View {
    Text(title.uppercased())
        .dsFont(DS.Typography.subheadingXS)
        .foregroundStyle(DS.Color.textSoft)
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let maxWidth = proposal.width ?? .infinity
        var x: CGFloat = 0
        var y: CGFloat = 0
        var lineH: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0; y += lineH + spacing; lineH = 0
            }
            x += size.width + spacing
            lineH = max(lineH, size.height)
        }
        return CGSize(width: maxWidth, height: y + lineH)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var x = bounds.minX
        var y = bounds.minY
        var lineH: CGFloat = 0

        for sub in subviews {
            let size = sub.sizeThatFits(.unspecified)
            if x + size.width > bounds.maxX, x > bounds.minX {
                x = bounds.minX; y += lineH + spacing; lineH = 0
            }
            sub.place(at: CGPoint(x: x, y: y), proposal: .unspecified)
            x += size.width + spacing
            lineH = max(lineH, size.height)
        }
    }
}
