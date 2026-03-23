// DSCard.swift
// DesignSystem/Components/Layout/DSCard.swift
//
// Построен на DS.* токенах без Figma-ноды.
// Универсальный контейнер: elevated / outlined / flat
// Поддерживает заголовок, футер, интерактивность.

import SwiftUI

// MARK: - DSCard

struct DSCard<Content: View>: View {

    // MARK: - Style

    enum CardStyle {
        /// Белый фон + тень (дефолт)
        case elevated
        /// Белый фон + border, без тени
        case outlined
        /// Прозрачный фон, без border и тени (просто отступы)
        case flat
        /// Светло-серый фон (#F6F8FA), без тени
        case surface
    }

    // MARK: - Properties

    var style: CardStyle = .elevated
    var padding: CGFloat = DS.Spacing.s16
    var cornerRadius: CGFloat = DS.Radius.md     // 12pt
    var title: String? = nil
    var subtitle: String? = nil
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    var onTap: (() -> Void)? = nil
    var isDisabled: Bool = false
    @ViewBuilder var content: () -> Content

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Header — если есть title
            if title != nil || subtitle != nil {
                headerView
                DSDivider(type: .line)
            }

            // Контент
            content()
                .padding(padding)
        }
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .strokeBorder(border, lineWidth: 1)
        )
        .modifier(CardShadowModifier(style: style))
        .opacity(isDisabled ? 0.5 : 1)
        .onTapGesture { if let onTap, !isDisabled { onTap() } }
        .animation(DS.Animation.fast, value: isDisabled)
    }

    // MARK: - Header

    @ViewBuilder
    private var headerView: some View {
        HStack(alignment: .center, spacing: DS.Spacing.s8) {
            VStack(alignment: .leading, spacing: 2) {
                if let title {
                    Text(title)
                        .dsFont(DS.Typography.labelMd)
                        .foregroundStyle(DS.Color.textMain)
                }
                if let subtitle {
                    Text(subtitle)
                        .dsFont(DS.Typography.paragraphXS)
                        .foregroundStyle(DS.Color.textSoft)
                }
            }
            Spacer()
            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .dsFont(DS.Typography.labelXS)
                        .foregroundStyle(DS.Color.brandPrimary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, padding)
        .padding(.vertical, DS.Spacing.s12)
    }

    // MARK: - Computed

    private var background: Color {
        switch style {
        case .elevated, .outlined: return DS.Color.bgWhite
        case .flat:                return .clear
        case .surface:             return DS.Color.bgWeak
        }
    }

    private var border: Color {
        switch style {
        case .outlined: return DS.Color.strokeSoft
        default:        return .clear
        }
    }
}

// MARK: - Shadow Modifier

private struct CardShadowModifier: ViewModifier {
    let style: DSCard<EmptyView>.CardStyle

    func body(content: Content) -> some View {
        switch style {
        case .elevated:
            content.dsShadow(DS.Shadow.sm)
        default:
            content
        }
    }
}

// MARK: - Convenience Inits

extension DSCard {

    /// Простой контейнер без заголовка
    init(
        style: CardStyle = .elevated,
        padding: CGFloat = DS.Spacing.s16,
        cornerRadius: CGFloat = DS.Radius.md,
        onTap: (() -> Void)? = nil,
        isDisabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.onTap = onTap
        self.isDisabled = isDisabled
        self.content = content
    }

    /// Карточка с заголовком и опциональной кнопкой-действием
    init(
        title: String,
        subtitle: String? = nil,
        style: CardStyle = .elevated,
        padding: CGFloat = DS.Spacing.s16,
        cornerRadius: CGFloat = DS.Radius.md,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil,
        isDisabled: Bool = false,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.actionTitle = actionTitle
        self.action = action
        self.onTap = onTap
        self.isDisabled = isDisabled
        self.content = content
    }
}

// MARK: - Preview

#Preview("DSCard — все варианты") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.s24) {

            // Стили
            sectionHeader("Стили")

            DSCard(style: .elevated) {
                Text("Elevated — белый фон + тень").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
            }
            DSCard(style: .outlined) {
                Text("Outlined — белый фон + border").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
            }
            DSCard(style: .surface) {
                Text("Surface — серый фон (#F6F8FA)").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
            }
            DSCard(style: .flat) {
                Text("Flat — без фона, только отступы").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
            }

            // С заголовком
            sectionHeader("С заголовком")

            DSCard(title: "Транзакции") {
                VStack(spacing: DS.Spacing.s8) {
                    ForEach(["Apple Pay +500₽", "Кофе -180₽", "Зарплата +80 000₽"], id: \.self) { item in
                        Text(item).dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textMain)
                    }
                }
            }

            DSCard(title: "Аналитика", subtitle: "За последние 30 дней", actionTitle: "Все", action: {}) {
                HStack {
                    statItem(value: "12 450", label: "Доходы")
                    Spacer()
                    statItem(value: "8 200", label: "Расходы")
                    Spacer()
                    statItem(value: "4 250", label: "Баланс")
                }
            }

            // Интерактивная
            sectionHeader("Интерактивная")

            DSCard(style: .outlined, onTap: {}) {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundStyle(DS.Color.brandPrimary)
                        .font(.system(size: 20))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Visa •••• 4242").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textMain)
                        Text("Expires 12/26").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(DS.Color.textSoft)
                }
            }

            // Disabled
            sectionHeader("Disabled")

            DSCard(style: .elevated, isDisabled: true) {
                Text("Недоступная карточка").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
            }

            // Без паддинга (кастомный)
            sectionHeader("Кастомный паддинг")

            DSCard(style: .elevated, padding: 0) {
                VStack(spacing: 0) {
                    Color(DS.Color.brandPrimaryLighter)
                        .frame(height: 80)
                        .overlay(
                            Image(systemName: "map.fill")
                                .font(.system(size: 32))
                                .foregroundStyle(DS.Color.brandPrimary)
                        )
                    VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                        Text("Карта отделений").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textMain)
                        Text("Найди ближайший офис").dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
                    }
                    .padding(DS.Spacing.s16)
                }
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

private func statItem(value: String, label: String) -> some View {
    VStack(spacing: 2) {
        Text(value).dsFont(DS.Typography.labelMd).foregroundStyle(DS.Color.textMain)
        Text(label).dsFont(DS.Typography.paragraphXS).foregroundStyle(DS.Color.textSoft)
    }
}
