// DSButton.swift
// DesignSystem/Components/Buttons/DSButton.swift
//
// Сгенерировано из Figma — MS Design System 2
// node-id: 1673:39255
// Поддерживает: Type × Style × Size × State × OnlyIcon
// Дополнительные размеры: 48, 56, 64pt (расширение базовых правил)

import SwiftUI

// MARK: - DSButton

struct DSButton: View {

    // MARK: - Types

    enum ButtonType {
        case primary  // Синий #375DFB
        case neutral  // Тёмный #20232D
        case error    // Красный #DF1C41
    }

    enum ButtonStyle {
        case filled   // Заливка цветом типа
        case stroke   // Белый фон + бордер цвета типа
        case lighter  // Светлый тинт фона
        case ghost    // Без фона, только текст+иконка
    }

    enum ButtonSize {
        case xSmall   // 32pt — из Figma
        case small    // 36pt — из Figma
        case medium   // 40pt — из Figma (дефолт)
        case large    // 48pt — расширение
        case xLarge   // 56pt — расширение
        case xxLarge  // 64pt — расширение
    }

    // MARK: - Properties

    var title: String = ""
    var type: ButtonType = .primary
    var style: ButtonStyle = .filled
    var size: ButtonSize = .medium
    var isDisabled: Bool = false
    var isFullWidth: Bool = false
    var onlyIcon: Bool = false
    var leftIcon: String? = nil    // SF Symbol
    var rightIcon: String? = nil   // SF Symbol
    var action: () -> Void = {}

    // MARK: - Body

    var body: some View {
        Button(action: { if !isDisabled { action() } }) {
            HStack(spacing: iconSpacing) {
                if onlyIcon {
                    // Only Icon режим
                    if let icon = leftIcon ?? rightIcon {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
                    }
                } else {
                    // Стандартный режим: [leftIcon] [label] [rightIcon]
                    if let left = leftIcon {
                        Image(systemName: left)
                            .font(.system(size: 20))
                            .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
                    }

                    if !title.isEmpty {
                        Text(title)
                            .dsFont(DS.Typography.labelSm)
                            .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
                            .lineLimit(1)
                    }

                    if let right = rightIcon {
                        Image(systemName: right)
                            .font(.system(size: 20))
                            .foregroundStyle(isDisabled ? DS.Color.textDisabled : foregroundColor)
                    }
                }
            }
            .padding(buttonPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil, alignment: .center)
            .background(isDisabled ? disabledBackground : background)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        isDisabled ? SwiftUI.Color.clear : borderColor,
                        lineWidth: style == .stroke ? 1 : 0
                    )
            )
            .shadow(
                color: isDisabled ? .clear : shadowColor,
                radius: 2, x: 0, y: 1
            )
        }
        .disabled(isDisabled)
    }

    // MARK: - Размеры из Figma

    private var buttonPadding: EdgeInsets {
        switch size {
        case .xSmall:  return EdgeInsets(top: 6,  leading: 6,  bottom: 6,  trailing: 6)   // 32pt total
        case .small:   return EdgeInsets(top: 8,  leading: 8,  bottom: 8,  trailing: 8)   // 36pt total
        case .medium:  return EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)  // 40pt total
        case .large:   return EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16)  // 48pt total
        case .xLarge:  return EdgeInsets(top: 18, leading: 20, bottom: 18, trailing: 20)  // 56pt total
        case .xxLarge: return EdgeInsets(top: 22, leading: 24, bottom: 22, trailing: 24)  // 64pt total
        }
    }

    private var iconSpacing: CGFloat {
        switch size {
        case .xSmall:  return 2
        case .small:   return 4
        default:       return 4
        }
    }

    private var cornerRadius: CGFloat {
        switch size {
        case .xSmall, .small: return DS.Radius.xs  // 8pt — из Figma
        case .medium:         return DS.Radius.sm  // 10pt — из Figma
        case .large:          return DS.Radius.sm  // 10pt
        case .xLarge:         return DS.Radius.md  // 12pt
        case .xxLarge:        return DS.Radius.md  // 12pt
        }
    }

    // MARK: - Цвета из Figma

    // Основной цвет типа
    private var typeColor: SwiftUI.Color {
        switch type {
        case .primary: return DS.Color.brandPrimary      // #375DFB
        case .neutral: return DS.Color.neutralBase       // #20232D
        case .error:   return DS.Color.error             // #DF1C41
        }
    }

    // Лёгкий тинт для Lighter стиля
    private var lighterColor: SwiftUI.Color {
        switch type {
        case .primary: return DS.Color.brandPrimaryLighter  // #EBF1FF
        case .neutral: return DS.Color.bgWeak               // #F6F8FA
        case .error:   return DS.Color.errorLighter         // #FDEDF0
        }
    }

    // Фон кнопки
    private var background: SwiftUI.Color {
        switch style {
        case .filled:  return typeColor
        case .stroke:  return DS.Color.bgWhite
        case .lighter: return lighterColor
        case .ghost:   return .clear
        }
    }

    // Disabled фон
    private var disabledBackground: SwiftUI.Color {
        switch style {
        case .ghost: return .clear
        default:     return DS.Color.bgWeak  // #F6F8FA
        }
    }

    // Цвет текста и иконок
    private var foregroundColor: SwiftUI.Color {
        switch style {
        case .filled:  return DS.Color.textWhite
        case .stroke:  return type == .neutral ? DS.Color.textSub : typeColor
        case .lighter: return type == .neutral ? DS.Color.textSub : typeColor
        case .ghost:   return type == .neutral ? DS.Color.textSub : typeColor
        }
    }

    // Цвет бордера (только для Stroke)
    private var borderColor: SwiftUI.Color {
        switch type {
        case .primary: return DS.Color.brandPrimary    // #375DFB
        case .neutral: return DS.Color.strokeSoft      // #E2E4E9
        case .error:   return DS.Color.error           // #DF1C41
        }
    }

    // Тени точно из Figma
    private var shadowColor: SwiftUI.Color {
        switch style {
        case .ghost, .lighter:
            return .clear
        case .filled, .stroke:
            switch type {
            case .primary: return SwiftUI.Color(hex: "#375DFB").opacity(0.08)  // button-shadow/stroke/primary
            case .neutral: return SwiftUI.Color(hex: "#525866").opacity(0.06)  // button-shadow/stroke/important
            case .error:   return SwiftUI.Color(hex: "#E93535").opacity(0.08)  // button-shadow/stroke/error
            }
        }
    }
}

// MARK: - Convenience Inits

extension DSButton {

    // Текстовая кнопка с иконками
    init(
        _ title: String,
        type: ButtonType = .primary,
        style: ButtonStyle = .filled,
        size: ButtonSize = .medium,
        isDisabled: Bool = false,
        isFullWidth: Bool = false,
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.type = type
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.isFullWidth = isFullWidth
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.action = action
    }

    // Кнопка только с иконкой
    init(
        icon: String,
        type: ButtonType = .primary,
        style: ButtonStyle = .filled,
        size: ButtonSize = .medium,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.leftIcon = icon
        self.onlyIcon = true
        self.type = type
        self.style = style
        self.size = size
        self.isDisabled = isDisabled
        self.action = action
    }
}

// MARK: - Preview

#Preview("DSButton — все варианты") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.s24) {

            // FILLED
            Group {
                Text("Filled").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSButton("Primary", action: {})
                    DSButton("Neutral", type: .neutral, action: {})
                    DSButton("Error", type: .error, action: {})
                }
                HStack(spacing: DS.Spacing.s8) {
                    DSButton("Disabled", isDisabled: true, action: {})
                    DSButton(icon: "plus", action: {})
                }
            }

            // STROKE
            Group {
                Text("Stroke").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSButton("Primary", style: .stroke, action: {})
                    DSButton("Neutral", type: .neutral, style: .stroke, action: {})
                    DSButton("Error", type: .error, style: .stroke, action: {})
                }
            }

            // LIGHTER
            Group {
                Text("Lighter").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSButton("Primary", style: .lighter, action: {})
                    DSButton("Neutral", type: .neutral, style: .lighter, action: {})
                    DSButton("Error", type: .error, style: .lighter, action: {})
                }
            }

            // GHOST
            Group {
                Text("Ghost").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSButton("Primary", style: .ghost, action: {})
                    DSButton("Neutral", type: .neutral, style: .ghost, action: {})
                    DSButton("Error", type: .error, style: .ghost, action: {})
                }
            }

            // SIZES
            Group {
                Text("Sizes").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                DSButton("XSmall (32pt)", size: .xSmall, action: {})
                DSButton("Small (36pt)", size: .small, action: {})
                DSButton("Medium (40pt)", size: .medium, action: {})
                DSButton("Large (48pt)", size: .large, action: {})
                DSButton("XLarge (56pt)", size: .xLarge, action: {})
                DSButton("XXLarge (64pt)", size: .xxLarge, action: {})
            }

            // WITH ICONS
            Group {
                Text("С иконками").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)
                DSButton("С левой", leftIcon: "arrow.left", action: {})
                DSButton("С правой", rightIcon: "arrow.right", action: {})
                DSButton("Обе", leftIcon: "arrow.left", rightIcon: "arrow.right", action: {})
                HStack(spacing: DS.Spacing.s8) {
                    DSButton(icon: "plus", size: .xSmall, action: {})
                    DSButton(icon: "plus", size: .small, action: {})
                    DSButton(icon: "plus", size: .medium, action: {})
                    DSButton(icon: "plus", type: .neutral, style: .stroke, action: {})
                    DSButton(icon: "trash", type: .error, style: .lighter, action: {})
                }
            }
        }
        .padding(DS.Spacing.s16)
    }
    .background(DS.Color.bgWeak)
}
