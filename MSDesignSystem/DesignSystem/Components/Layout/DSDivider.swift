// DSDivider.swift
// DesignSystem/Components/Layout/DSDivider.swift
//
// Из Figma — MS Design System 2
// node-id: 3553:49508
//
// Типы: line / lineSpacing / textLine / textOnly / solidText / iconButton / textButton

import SwiftUI

// MARK: - DSDivider

struct DSDivider: View {

    // MARK: - Type

    enum DividerType {
        /// Простая линия (1pt, strokeSoft)
        case line
        /// Линия с вертикальными отступами
        case lineSpacing
        /// Линия с текстом по центру: ——— OR ———
        case textLine(String)
        /// Только текст (uppercase, textSoft) — секция-разделитель
        case textOnly(String)
        /// Серый фон + uppercase текст — для разделения секций
        case solidText(String)
        /// Линия + иконка-кнопка по центру
        case iconButton(icon: String, action: () -> Void)
        /// Линия + текстовая кнопка по центру
        case textButton(title: String, action: () -> Void)
    }

    var type: DividerType = .line

    // MARK: - Body

    var body: some View {
        switch type {
        case .line:
            lineView

        case .lineSpacing:
            lineView.padding(.vertical, 1.5)

        case .textLine(let text):
            HStack(spacing: DS.Spacing.s10) {
                lineView
                Text(text)
                    .dsFont(DS.Typography.subheading2XS)
                    .foregroundStyle(DS.Color.textSoft)
                    .fixedSize()
                lineView
            }

        case .textOnly(let text):
            HStack {
                Text(text.uppercased())
                    .dsFont(DS.Typography.subheadingXS)
                    .foregroundStyle(DS.Color.textSoft)
                Spacer()
            }
            .padding(.horizontal, DS.Spacing.s8)
            .padding(.vertical, DS.Spacing.xs)

        case .solidText(let text):
            HStack {
                Text(text.uppercased())
                    .dsFont(DS.Typography.subheadingXS)
                    .foregroundStyle(DS.Color.textSoft)
                Spacer()
            }
            .padding(.horizontal, DS.Spacing.s24)
            .padding(.vertical, 6)
            .background(DS.Color.bgWeak)

        case .iconButton(let icon, let action):
            HStack(spacing: DS.Spacing.s10) {
                lineView
                Button(action: action) {
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundStyle(DS.Color.textSub)
                        .padding(6)
                        .background(DS.Color.bgWhite)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xs))
                        .overlay(
                            RoundedRectangle(cornerRadius: DS.Radius.xs)
                                .strokeBorder(DS.Color.strokeSoft, lineWidth: 1)
                        )
                        .dsShadow(DS.Shadow.xSmall)
                }
                lineView
            }

        case .textButton(let title, let action):
            HStack(spacing: DS.Spacing.s10) {
                lineView
                Button(action: action) {
                    Text(title)
                        .dsFont(DS.Typography.labelSm)
                        .foregroundStyle(DS.Color.textSub)
                        .padding(.horizontal, DS.Spacing.s12)
                        .padding(.vertical, DS.Spacing.s8)
                        .background(DS.Color.bgWhite)
                        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xs))
                        .overlay(
                            RoundedRectangle(cornerRadius: DS.Radius.xs)
                                .strokeBorder(DS.Color.strokeSoft, lineWidth: 1)
                        )
                        .dsShadow(DS.Shadow.xSmall)
                }
                lineView
            }
        }
    }

    // MARK: - Line

    private var lineView: some View {
        Rectangle()
            .fill(DS.Color.strokeSoft)   // #E2E4E9
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
}

// MARK: - Preview

#Preview("DSDivider — все типы") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.s24) {

            sectionLabel("Line")
            DSDivider(type: .line)

            sectionLabel("Line Spacing")
            DSDivider(type: .lineSpacing)

            sectionLabel("Text & Line — OR")
            DSDivider(type: .textLine("OR"))

            sectionLabel("Text & Line — пример с датой")
            DSDivider(type: .textLine("Today"))

            sectionLabel("Text Only")
            DSDivider(type: .textOnly("Настройки аккаунта"))

            sectionLabel("Solid Text")
            DSDivider(type: .solidText("Amount & Account"))

            sectionLabel("Icon Button")
            DSDivider(type: .iconButton(icon: "plus", action: {}))

            sectionLabel("Text Button")
            DSDivider(type: .textButton(title: "Add Section", action: {}))

            // Пример использования в списке
            sectionLabel("В реальном контексте")
            VStack(spacing: 0) {
                rowItem("Имя", value: "Иван Иванов")
                DSDivider(type: .line).padding(.leading, DS.Spacing.s16)
                rowItem("Email", value: "ivan@mail.ru")
                DSDivider(type: .line).padding(.leading, DS.Spacing.s16)
                rowItem("Телефон", value: "+7 999 000 00 00")
            }
            .background(DS.Color.bgWhite)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
        }
        .padding(DS.Spacing.s16)
    }
    .background(DS.Color.bgWeak)
}

private func sectionLabel(_ text: String) -> some View {
    Text(text.uppercased())
        .dsFont(DS.Typography.subheadingXS)
        .foregroundStyle(DS.Color.textSoft)
}

private func rowItem(_ title: String, value: String) -> some View {
    HStack {
        Text(title).dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
        Spacer()
        Text(value).dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textMain)
    }
    .padding(.horizontal, DS.Spacing.s16)
    .padding(.vertical, DS.Spacing.s12)
}
