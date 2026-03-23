// DSSwitchToggle.swift
// DesignSystem/Components/Controls/DSSwitchToggle.swift
//
// Из Figma — MS Design System 2
// Switch Toggle Items node-id: 1559:36805
// Switch Toggle      node-id: 1559:37047
//
// Аналог iOS Picker(.segmented) в стиле дизайн-системы.
// Поддерживает 2–4 таба, три типа контента: текст / иконка+текст / только иконка.

import SwiftUI

// MARK: - DSSwitchTab (модель таба)

struct DSSwitchTab {
    var title: String?
    var icon: String?           // SF Symbol name
    var isDisabled: Bool = false

    /// Только текст
    init(_ title: String, isDisabled: Bool = false) {
        self.title = title
        self.isDisabled = isDisabled
    }

    /// Иконка + текст
    init(_ title: String, icon: String, isDisabled: Bool = false) {
        self.title = title
        self.icon = icon
        self.isDisabled = isDisabled
    }

    /// Только иконка
    init(icon: String, isDisabled: Bool = false) {
        self.icon = icon
        self.isDisabled = isDisabled
    }
}

// MARK: - DSSwitchToggle

struct DSSwitchToggle: View {

    // MARK: - Properties

    @Binding var selectedIndex: Int
    var tabs: [DSSwitchTab]

    /// Заголовок над контролом (опционально)
    var label: String? = nil
    /// Показывать звёздочку обязательного поля
    var isRequired: Bool = false
    /// Подпись рядом с заголовком, например "(Optional)"
    var sublabel: String? = nil

    @Namespace private var animation

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s8) {
            if let label { headerView(label) }
            toggleContainer
        }
    }

    // MARK: - Container

    private var toggleContainer: some View {
        HStack(spacing: DS.Spacing.xs) {
            ForEach(tabs.indices, id: \.self) { index in
                tabButton(index: index)
            }
        }
        .padding(DS.Spacing.xs)            // 4pt padding
        .background(DS.Color.bgWeak)       // #F6F8FA
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }

    // MARK: - Tab Button

    @ViewBuilder
    private func tabButton(index: Int) -> some View {
        let tab = tabs[index]
        let isActive = selectedIndex == index

        Button {
            guard !tab.isDisabled else { return }
            withAnimation(DS.Animation.standard) { selectedIndex = index }
        } label: {
            tabLabel(tab: tab, isActive: isActive)
                .frame(maxWidth: .infinity, minHeight: 28)
                .background { activeBackground(isActive: isActive) }
        }
        .buttonStyle(.plain)
        .disabled(tab.isDisabled)
    }

    // Контент внутри таба
    @ViewBuilder
    private func tabLabel(tab: DSSwitchTab, isActive: Bool) -> some View {
        let isOnlyIcon  = tab.icon != nil && tab.title == nil
        let isIconText  = tab.icon != nil && tab.title != nil
        let padH: CGFloat = isOnlyIcon || isIconText ? 4 : 2

        HStack(spacing: 6) {
            if let icon = tab.icon {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(contentColor(isActive: isActive, isDisabled: tab.isDisabled))
            }
            if let title = tab.title {
                Text(title)
                    .dsFont(DS.Typography.labelSm)
                    .foregroundStyle(contentColor(isActive: isActive, isDisabled: tab.isDisabled))
                    .lineLimit(1)
            }
        }
        .padding(.horizontal, padH)
        .padding(.vertical, DS.Spacing.xs)
    }

    // Белый фон активного таба с анимацией
    @ViewBuilder
    private func activeBackground(isActive: Bool) -> some View {
        if isActive {
            RoundedRectangle(cornerRadius: 6)
                .fill(DS.Color.bgWhite)
                .matchedGeometryEffect(id: "activeTab", in: animation)
                // Figma: toggle-shadow/switch-toggle/Active
                .shadow(color: Color(hex: "#1B1C1D").opacity(0.06), radius: 10, x: 0, y: 6)
                .shadow(color: Color(hex: "#1B1C1D").opacity(0.02), radius: 4,  x: 0, y: 2)
        }
    }

    // MARK: - Header

    @ViewBuilder
    private func headerView(_ text: String) -> some View {
        HStack(spacing: 2) {
            Text(text)
                .dsFont(DS.Typography.labelSm)
                .foregroundStyle(DS.Color.textMain)

            if isRequired {
                Text("*")
                    .dsFont(DS.Typography.labelSm)
                    .foregroundStyle(DS.Color.brandPrimary)
            }

            if let sub = sublabel {
                Text(sub)
                    .dsFont(DS.Typography.paragraphSm)
                    .foregroundStyle(DS.Color.textSub)
            }
        }
    }

    // MARK: - Colors

    private func contentColor(isActive: Bool, isDisabled: Bool) -> Color {
        if isDisabled { return DS.Color.textDisabled }  // #CDD0D5
        return isActive ? DS.Color.textMain : DS.Color.textSoft  // #0A0D14 / #868C98
    }
}

// MARK: - Preview

private struct DSSwitchTogglePreview: View {

    @State private var sel1 = 0
    @State private var sel2 = 0
    @State private var sel3 = 0
    @State private var sel4 = 0
    @State private var sel5 = 0
    @State private var sel6 = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                // Только текст
                sectionHeader("Только текст — 2 таба")
                DSSwitchToggle(
                    selectedIndex: $sel1,
                    tabs: [DSSwitchTab("Monthly"), DSSwitchTab("Yearly")]
                )

                sectionHeader("Только текст — 3 таба")
                DSSwitchToggle(
                    selectedIndex: $sel2,
                    tabs: [DSSwitchTab("Day"), DSSwitchTab("Month"), DSSwitchTab("Year")]
                )

                // Иконка + текст
                sectionHeader("Иконка + текст")
                DSSwitchToggle(
                    selectedIndex: $sel3,
                    tabs: [
                        DSSwitchTab("Grid",  icon: "square.grid.2x2"),
                        DSSwitchTab("List",  icon: "list.bullet"),
                        DSSwitchTab("Map",   icon: "map")
                    ]
                )

                // Только иконки
                sectionHeader("Только иконки")
                DSSwitchToggle(
                    selectedIndex: $sel4,
                    tabs: [
                        DSSwitchTab(icon: "square.grid.2x2"),
                        DSSwitchTab(icon: "list.bullet"),
                        DSSwitchTab(icon: "map")
                    ]
                )

                // С заголовком
                sectionHeader("С заголовком и подписью")
                DSSwitchToggle(
                    selectedIndex: $sel5,
                    tabs: [DSSwitchTab("Monthly"), DSSwitchTab("Quarterly"), DSSwitchTab("Yearly")],
                    label: "Period",
                    isRequired: true,
                    sublabel: "(Optional)"
                )

                // С disabled табом
                sectionHeader("С disabled табом")
                DSSwitchToggle(
                    selectedIndex: $sel6,
                    tabs: [
                        DSSwitchTab("Active"),
                        DSSwitchTab("Disabled", isDisabled: true),
                        DSSwitchTab("Also Active")
                    ]
                )
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

#Preview("DSSwitchToggle — все варианты") {
    DSSwitchTogglePreview()
}
