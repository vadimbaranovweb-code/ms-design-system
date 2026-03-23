// DSInputField.swift
// DesignSystem/Components/Inputs/DSInputField.swift
//
// Сгенерировано из Figma — MS Design System 2
// Поддерживает: State × Size × Icons × Label × Hint × Error

import SwiftUI

// MARK: - DSInputField

struct DSInputField: View {

    // MARK: - Types

    enum InputState {
        case `default`   // Нейтральный бордер #E2E4E9
        case focused     // Синий бордер #375DFB
        case error       // Красный бордер #DF1C41
        case disabled    // Серый фон, всё неактивно
    }

    enum InputSize {
        case small   // 36pt высота
        case medium  // 44pt высота (дефолт)
        case large   // 52pt высота
    }

    // MARK: - Properties

    @Binding var text: String
    var placeholder: String = ""
    var state: InputState = .default
    var size: InputSize = .medium
    var label: String? = nil
    var hint: String? = nil
    var errorText: String? = nil
    var leftIcon: String? = nil   // SF Symbol
    var rightIcon: String? = nil  // SF Symbol

    // MARK: - Private

    @FocusState private var isFocused: Bool

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s4) {

            // Label
            if let label {
                Text(label)
                    .dsFont(DS.Typography.labelSm)
                    .foregroundStyle(state == .disabled ? DS.Color.textDisabled : DS.Color.textSub)
            }

            // Input container
            HStack(spacing: DS.Spacing.s8) {

                if let leftIcon {
                    Image(systemName: leftIcon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }

                TextField(placeholder, text: $text)
                    .dsFont(DS.Typography.paragraphSm)
                    .foregroundStyle(state == .disabled ? DS.Color.textDisabled : DS.Color.textMain)
                    .disabled(state == .disabled)
                    .focused($isFocused)
                    .tint(DS.Color.brandPrimary)

                if let rightIcon {
                    Image(systemName: rightIcon)
                        .font(.system(size: 16))
                        .foregroundStyle(iconColor)
                }
            }
            .padding(inputPadding)
            .frame(minHeight: inputHeight)
            .background(backgroundColor)
            .cornerRadius(DS.Radius.xs)
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.xs)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .onTapGesture {
                if state != .disabled {
                    isFocused = true
                }
            }

            // Hint / Error text
            if state == .error, let errorText {
                HStack(spacing: DS.Spacing.s4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(DS.Color.error)
                    Text(errorText)
                        .dsFont(DS.Typography.paragraphXS)
                        .foregroundStyle(DS.Color.error)
                }
            } else if let hint {
                Text(hint)
                    .dsFont(DS.Typography.paragraphXS)
                    .foregroundStyle(DS.Color.textSoft)
            }
        }
    }

    // MARK: - Computed

    private var resolvedState: InputState {
        if isFocused && state == .default { return .focused }
        return state
    }

    private var inputHeight: CGFloat {
        switch size {
        case .small:  return 36
        case .medium: return 44
        case .large:  return 52
        }
    }

    private var inputPadding: EdgeInsets {
        switch size {
        case .small:  return EdgeInsets(top: 8,  leading: 10, bottom: 8,  trailing: 10)
        case .medium: return EdgeInsets(top: 10, leading: 12, bottom: 10, trailing: 12)
        case .large:  return EdgeInsets(top: 14, leading: 14, bottom: 14, trailing: 14)
        }
    }

    private var backgroundColor: SwiftUI.Color {
        switch state {
        case .disabled: return DS.Color.bgWeak
        default:        return DS.Color.bgWhite
        }
    }

    private var borderColor: SwiftUI.Color {
        switch resolvedState {
        case .default:  return DS.Color.strokeSoft      // #E2E4E9
        case .focused:  return DS.Color.brandPrimary    // #375DFB
        case .error:    return DS.Color.error           // #DF1C41
        case .disabled: return DS.Color.strokeSoft      // #E2E4E9
        }
    }

    private var borderWidth: CGFloat {
        switch resolvedState {
        case .focused: return 1.5
        case .error:   return 1.5
        default:       return 1
        }
    }

    private var iconColor: SwiftUI.Color {
        switch state {
        case .disabled: return DS.Color.textDisabled
        case .error:    return DS.Color.error
        default:        return isFocused ? DS.Color.brandPrimary : DS.Color.textSoft
        }
    }
}

// MARK: - Convenience Inits

extension DSInputField {

    // Простое поле с биндингом и плейсхолдером
    init(
        _ placeholder: String,
        text: Binding<String>,
        state: InputState = .default,
        size: InputSize = .medium
    ) {
        self.placeholder = placeholder
        self._text = text
        self.state = state
        self.size = size
    }

    // Поле с иконками
    init(
        _ placeholder: String,
        text: Binding<String>,
        leftIcon: String? = nil,
        rightIcon: String? = nil,
        state: InputState = .default,
        size: InputSize = .medium
    ) {
        self.placeholder = placeholder
        self._text = text
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.state = state
        self.size = size
    }
}

// MARK: - Preview

#Preview("DSInputField — все варианты") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.s24) {

            // STATES
            Group {
                Text("States").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)

                DSInputField(
                    "Email",
                    text: .constant(""),
                    leftIcon: "envelope"
                )

                DSInputField(
                    "Focused",
                    text: .constant("user@example.com"),
                    leftIcon: "envelope",
                    state: .focused
                )

                DSInputField(
                    "Error state",
                    text: .constant("invalid"),
                    leftIcon: "envelope",
                    state: .error
                )
                .modifier(DSInputFieldErrorModifier(errorText: "Некорректный email"))

                DSInputField(
                    "Disabled",
                    text: .constant("disabled@example.com"),
                    leftIcon: "envelope",
                    state: .disabled
                )
            }

            // WITH LABEL & HINT
            Group {
                Text("Label + Hint").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)

                DSInputField(text: .constant(""), placeholder: "Введите имя")
                    .modifier(DSInputFieldLabelModifier(label: "Имя", hint: "Как вас зовут?"))
            }

            // SIZES
            Group {
                Text("Sizes").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)

                DSInputField("Small (36pt)", text: .constant(""), size: .small)
                DSInputField("Medium (44pt)", text: .constant(""), size: .medium)
                DSInputField("Large (52pt)", text: .constant(""), size: .large)
            }

            // WITH ICONS
            Group {
                Text("С иконками").dsFont(DS.Typography.subheadingMd)
                    .foregroundStyle(DS.Color.textSub)

                DSInputField("Поиск...", text: .constant(""), leftIcon: "magnifyingglass")
                DSInputField("Пароль", text: .constant(""), rightIcon: "eye.slash")
                DSInputField(
                    "С обеими",
                    text: .constant(""),
                    leftIcon: "person",
                    rightIcon: "chevron.down"
                )
            }
        }
        .padding(DS.Spacing.s16)
    }
    .background(DS.Color.bgWeak)
}

// MARK: - Preview Helpers (только для Preview)

private struct DSInputFieldErrorModifier: ViewModifier {
    let errorText: String
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s4) {
            content
            HStack(spacing: DS.Spacing.s4) {
                Image(systemName: "exclamationmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(DS.Color.error)
                Text(errorText)
                    .dsFont(DS.Typography.paragraphXS)
                    .foregroundStyle(DS.Color.error)
            }
        }
    }
}

private struct DSInputFieldLabelModifier: ViewModifier {
    let label: String
    let hint: String
    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s4) {
            Text(label)
                .dsFont(DS.Typography.labelSm)
                .foregroundStyle(DS.Color.textSub)
            content
            Text(hint)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(DS.Color.textSoft)
        }
    }
}
