// DSTextArea.swift
// DesignSystem/Components/Inputs/DSTextArea.swift
//
// Из Figma — MS Design System 2
// node-id: 1750-44243
// States: default / filled / disabled / error
// Поддержка: label, hint, character counter, resize

import SwiftUI

// MARK: - DSTextArea

struct DSTextArea: View {

    // MARK: - Properties

    @Binding var text: String
    var label: String? = nil
    var isRequired: Bool = false
    var isOptional: Bool = false
    var showInfoIcon: Bool = false
    var placeholder: String = ""
    var hint: String? = nil
    var hintIcon: String? = nil
    var errorMessage: String? = nil
    var maxCharacters: Int? = nil
    var isDisabled: Bool = false
    var minHeight: CGFloat = 120

    @FocusState private var isFocused: Bool

    // MARK: - Computed State

    private var isError: Bool { errorMessage != nil }

    private var borderColor: Color {
        if isDisabled { return .clear }
        if isError    { return DS.Color.error }
        if isFocused  { return DS.Color.brandPrimary }
        return DS.Color.strokeSoft
    }

    private var bgColor: Color {
        isDisabled ? DS.Color.bgWeak : DS.Color.bgWhite
    }

    private var hintColor: Color {
        isError ? DS.Color.error : DS.Color.textSoft
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.xs) {
            // Label row
            if let label {
                labelRow(label)
            }

            // Field container
            VStack(alignment: .trailing, spacing: 0) {
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text(placeholder)
                            .dsFont(DS.Typography.paragraphSm)
                            .foregroundStyle(DS.Color.textDisabled)
                            .padding(.top, 1)
                            .allowsHitTesting(false)
                    }

                    TextEditor(text: $text)
                        .dsFont(DS.Typography.paragraphSm)
                        .foregroundStyle(isDisabled ? DS.Color.textDisabled : DS.Color.textMain)
                        .scrollContentBackground(.hidden)
                        .focused($isFocused)
                        .disabled(isDisabled)
                        .frame(minHeight: minHeight)
                        .onChange(of: text) { _, newValue in
                            if let max = maxCharacters, newValue.count > max {
                                text = String(newValue.prefix(max))
                            }
                        }
                }
                .padding(DS.Spacing.s12)

                // Bottom bar: counter + resize icon
                if maxCharacters != nil {
                    counterRow
                }
            }
            .background(bgColor)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.md)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .modifier(DSInputShadowModifier(isFocused: isFocused, isDisabled: isDisabled, isError: isError))
            .animation(DS.Animation.fast, value: isFocused)
            .animation(DS.Animation.fast, value: isError)

            // Hint / Error
            if let msg = errorMessage ?? hint {
                hintRow(msg)
            }
        }
    }

    // MARK: - Label Row

    private func labelRow(_ label: String) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            Text(label)
                .dsFont(DS.Typography.labelSm)
                .foregroundStyle(DS.Color.textMain)

            if isRequired {
                Text("*")
                    .dsFont(DS.Typography.labelSm)
                    .foregroundStyle(DS.Color.error)
            }

            if isOptional {
                Text("(Optional)")
                    .dsFont(DS.Typography.paragraphXS)
                    .foregroundStyle(DS.Color.textSoft)
            }

            if showInfoIcon {
                Image(systemName: "info.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(DS.Color.textSoft)
            }
        }
    }

    // MARK: - Counter Row

    private var counterRow: some View {
        HStack {
            Spacer()
            Text("\(text.count)/\(maxCharacters!)")
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(
                    text.count == maxCharacters
                        ? DS.Color.error
                        : DS.Color.textSoft
                )
            Image(systemName: "arrow.down.right.and.arrow.up.left")
                .font(.system(size: 10))
                .foregroundStyle(DS.Color.textSoft)
        }
        .padding(.horizontal, DS.Spacing.s12)
        .padding(.bottom, DS.Spacing.s8)
    }

    // MARK: - Hint Row

    private func hintRow(_ message: String) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            if let icon = hintIcon ?? (isError ? "exclamationmark.circle" : nil) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundStyle(hintColor)
            }
            Text(message)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(hintColor)
        }
    }
}

// MARK: - Shadow Modifier (shared with DSInputField)

private struct DSInputShadowModifier: ViewModifier {
    let isFocused: Bool
    let isDisabled: Bool
    let isError: Bool

    func body(content: Content) -> some View {
        if isDisabled {
            content
        } else if isError {
            content
                .shadow(color: DS.Color.error.opacity(0.12), radius: 4, x: 0, y: 2)
        } else if isFocused {
            content
                .shadow(color: DS.Color.brandPrimary.opacity(0.12), radius: 4, x: 0, y: 2)
        } else {
            content
                .shadow(color: Color(hex: "#525866").opacity(0.06), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Preview

#Preview("DSTextArea — все состояния") {
    struct PreviewWrapper: View {
        @State private var text1 = ""
        @State private var text2 = "Это заполненное поле. Пользователь уже ввёл текст."
        @State private var text3 = "Значение недоступно для редактирования."
        @State private var text4 = ""
        @State private var longText = ""

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                    sectionHeader("Default (пустой)")
                    DSTextArea(
                        text: $text1,
                        label: "Описание",
                        isRequired: true,
                        placeholder: "Введите описание...",
                        hint: "Максимум 500 символов",
                        hintIcon: "info.circle"
                    )

                    sectionHeader("Filled (заполнен)")
                    DSTextArea(
                        text: $text2,
                        label: "Комментарий",
                        placeholder: "Введите комментарий..."
                    )

                    sectionHeader("Disabled")
                    DSTextArea(
                        text: $text3,
                        label: "Заблокировано",
                        isDisabled: true
                    )

                    sectionHeader("Error")
                    DSTextArea(
                        text: $text4,
                        label: "Адрес",
                        isRequired: true,
                        placeholder: "Введите адрес...",
                        errorMessage: "Поле обязательно для заполнения",
                        maxCharacters: 200
                    )

                    sectionHeader("С счётчиком символов")
                    DSTextArea(
                        text: $longText,
                        label: "Отзыв",
                        isOptional: true,
                        showInfoIcon: true,
                        placeholder: "Поделитесь впечатлениями...",
                        hint: "Ваш отзыв поможет другим",
                        maxCharacters: 150
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
