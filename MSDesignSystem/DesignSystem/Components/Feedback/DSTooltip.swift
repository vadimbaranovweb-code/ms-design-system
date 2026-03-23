// DSTooltip.swift
// DesignSystem/Components/Feedback/DSTooltip.swift
//
// Из Figma — MS Design System 2
// node-id: 2009:54097
// Размеры: xxSmall / xSmall / large
// Темы: light / dark
// ViewModifier .dsTooltip() для привязки к любому View

import SwiftUI

// MARK: - DSTooltip

struct DSTooltip: View {

    // MARK: - Types

    enum TooltipSize {
        case xxSmall   // 24pt — только текст, 12pt, radius 4
        case xSmall    // 34pt — только текст, 14pt, radius 6
        case large     // 280pt — иконка + заголовок + описание + dismiss
    }

    enum TooltipTheme {
        case light  // bgWhite + border
        case dark   // #0A0D14 / #20232D
    }

    enum TailPosition {
        case topLeading, topCenter, topTrailing
        case bottomLeading, bottomCenter, bottomTrailing
        case none
    }

    // MARK: - Properties

    var text: String
    var description: String? = nil
    var size: TooltipSize = .xSmall
    var theme: TooltipTheme = .light
    var tailPosition: TailPosition = .topLeading
    var icon: String? = nil        // SF Symbol (только для large)
    var onDismiss: (() -> Void)? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Хвостик сверху
            if case .topLeading   = tailPosition { tailView(alignment: .leading) }
            if case .topCenter    = tailPosition { tailView(alignment: .center) }
            if case .topTrailing  = tailPosition { tailView(alignment: .trailing) }

            // Пузырь
            bubble

            // Хвостик снизу
            if case .bottomLeading   = tailPosition { tailView(alignment: .leading).rotationEffect(.degrees(180)) }
            if case .bottomCenter    = tailPosition { tailView(alignment: .center).rotationEffect(.degrees(180)) }
            if case .bottomTrailing  = tailPosition { tailView(alignment: .trailing).rotationEffect(.degrees(180)) }
        }
    }

    // MARK: - Bubble

    @ViewBuilder
    private var bubble: some View {
        switch size {
        case .xxSmall:
            Text(text)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(textColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(borderColor, lineWidth: 1))
                .tooltipShadow(theme: theme)

        case .xSmall:
            Text(text)
                .dsFont(DS.Typography.paragraphSm)
                .foregroundStyle(textColor)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(bgColor)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(borderColor, lineWidth: 1))
                .tooltipShadow(theme: theme)

        case .large:
            HStack(alignment: .top, spacing: DS.Spacing.s12) {
                // Иконка
                if let icon {
                    ZStack {
                        Circle()
                            .fill(iconBgColor)
                            .overlay(Circle().strokeBorder(iconBorderColor, lineWidth: 1))
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(textColor)
                    }
                    .frame(width: 32, height: 32)
                }

                // Текст
                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text(text)
                        .dsFont(DS.Typography.labelSm)
                        .foregroundStyle(textColor)
                    if let description {
                        Text(description)
                            .dsFont(DS.Typography.paragraphXS)
                            .foregroundStyle(descriptionColor)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Dismiss
                if let onDismiss {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(textColor.opacity(0.5))
                            .padding(2)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(DS.Spacing.s12)
            .frame(maxWidth: 280)
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
            .overlay(RoundedRectangle(cornerRadius: DS.Radius.md).strokeBorder(borderColor, lineWidth: 1))
            .tooltipShadow(theme: theme)
        }
    }

    // MARK: - Tail / Arrow

    private func tailView(alignment: HorizontalAlignment) -> some View {
        let tailW: CGFloat = size == .xxSmall ? 8 : 12
        let tailH: CGFloat = size == .xxSmall ? 4 : 6

        return HStack {
            if alignment == .center || alignment == .trailing { Spacer() }
            TooltipTailShape()
                .fill(bgColor)
                .frame(width: tailW, height: tailH)
                .overlay(
                    TooltipTailShape()
                        .stroke(borderColor, lineWidth: 1)
                )
            if alignment == .center || alignment == .leading { Spacer() }
        }
        .padding(.leading, alignment == .leading ? (size == .xxSmall ? 8 : 12) : 0)
        .padding(.trailing, alignment == .trailing ? (size == .xxSmall ? 8 : 12) : 0)
    }

    // MARK: - Colors

    private var bgColor: Color {
        switch theme {
        case .light: return DS.Color.bgWhite
        case .dark:
            return size == .large
                ? DS.Color.textMain           // #0A0D14
                : DS.Color.neutralBase        // #20232D
        }
    }

    private var borderColor: Color {
        switch theme {
        case .light: return DS.Color.strokeSoft
        case .dark:  return .clear
        }
    }

    private var textColor: Color {
        theme == .light ? DS.Color.textMain : DS.Color.textWhite
    }

    private var descriptionColor: Color {
        theme == .light ? DS.Color.textSub : DS.Color.textDisabled
    }

    private var iconBgColor: Color {
        theme == .light ? DS.Color.bgWhite : DS.Color.textMain
    }

    private var iconBorderColor: Color {
        theme == .light
            ? DS.Color.strokeSoft
            : DS.Color.neutralStrong   // #31353F
    }
}

// MARK: - Tail Shape (треугольник вверх)

private struct TooltipTailShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: rect.height))
        p.addLine(to: CGPoint(x: rect.width / 2, y: 0))
        p.addLine(to: CGPoint(x: rect.width, y: rect.height))
        p.closeSubpath()
        return p
    }
}

// MARK: - Shadow Modifier

private extension View {
    func tooltipShadow(theme: DSTooltip.TooltipTheme) -> some View {
        // Figma: tooltip-shadow/default-light
        self
            .shadow(color: Color(hex: "#E4E5E7").opacity(0.24), radius: 2, x: 0, y: 1)
            .shadow(color: Color(hex: "#868C98").opacity(0.12), radius: 24, x: 0, y: 12)
    }
}

// MARK: - ViewModifier

struct DSTooltipModifier: ViewModifier {
    @Binding var isVisible: Bool
    var text: String
    var description: String? = nil
    var size: DSTooltip.TooltipSize = .xSmall
    var theme: DSTooltip.TooltipTheme = .light
    var icon: String? = nil

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if isVisible {
                    DSTooltip(
                        text: text,
                        description: description,
                        size: size,
                        theme: theme,
                        tailPosition: .bottomCenter,
                        icon: icon,
                        onDismiss: { isVisible = false }
                    )
                    .offset(y: -8)
                    .fixedSize()
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .bottom)))
                    .zIndex(100)
                }
            }
            .animation(DS.Animation.fast, value: isVisible)
    }
}

extension View {
    func dsTooltip(
        isVisible: Binding<Bool>,
        text: String,
        description: String? = nil,
        size: DSTooltip.TooltipSize = .xSmall,
        theme: DSTooltip.TooltipTheme = .light,
        icon: String? = nil
    ) -> some View {
        modifier(DSTooltipModifier(
            isVisible: isVisible,
            text: text,
            description: description,
            size: size,
            theme: theme,
            icon: icon
        ))
    }
}

// MARK: - Preview

#Preview("DSTooltip — все варианты") {
    struct PreviewWrapper: View {
        @State private var show1 = true
        @State private var show2 = true
        @State private var show3 = true

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s32) {

                    sectionHeader("2X-Small")
                    HStack(spacing: DS.Spacing.s16) {
                        VStack(spacing: 0) {
                            DSTooltip(text: "Подсказка", size: .xxSmall, tailPosition: .topLeading)
                            dot
                        }
                        VStack(spacing: 0) {
                            DSTooltip(text: "Dark mode", size: .xxSmall, theme: .dark, tailPosition: .topLeading)
                            dot
                        }
                    }

                    sectionHeader("X-Small")
                    HStack(spacing: DS.Spacing.s16) {
                        VStack(spacing: 0) {
                            DSTooltip(text: "Tooltip label", size: .xSmall, tailPosition: .topLeading)
                            dot
                        }
                        VStack(spacing: 0) {
                            DSTooltip(text: "Dark tooltip", size: .xSmall, theme: .dark, tailPosition: .topLeading)
                            dot
                        }
                    }

                    sectionHeader("Large — Light")
                    VStack(spacing: 0) {
                        DSTooltip(
                            text: "Insert Tooltip",
                            description: "Insert tooltip description here. It would look better as three lines of text.",
                            size: .large,
                            theme: .light,
                            tailPosition: .topLeading,
                            icon: "globe",
                            onDismiss: {}
                        )
                        dot
                    }

                    sectionHeader("Large — Dark")
                    VStack(spacing: 0) {
                        DSTooltip(
                            text: "Insert Tooltip",
                            description: "Insert tooltip description here. It would look better as three lines of text.",
                            size: .large,
                            theme: .dark,
                            tailPosition: .topLeading,
                            icon: "globe",
                            onDismiss: {}
                        )
                        dot
                    }

                    sectionHeader(".dsTooltip() modifier")
                    HStack {
                        Button("Нажми меня") { show1.toggle() }
                            .dsFont(DS.Typography.labelSm)
                            .foregroundStyle(DS.Color.brandPrimary)
                            .dsTooltip(isVisible: $show1, text: "Привет! Это тултип")
                    }
                    .padding(DS.Spacing.s40)
                }
                .padding(DS.Spacing.s16)
            }
            .background(DS.Color.bgWeak)
        }

        var dot: some View {
            Circle()
                .fill(DS.Color.brandPrimary)
                .frame(width: 8, height: 8)
        }
    }
    return PreviewWrapper()
}

private func sectionHeader(_ text: String) -> some View {
    Text(text.uppercased())
        .dsFont(DS.Typography.subheadingXS)
        .foregroundStyle(DS.Color.textSoft)
}
