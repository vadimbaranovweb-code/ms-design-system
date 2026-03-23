// DSButtonGroup.swift
// DesignSystem/Components/Controls/DSButtonGroup.swift
//
// Из Figma — MS Design System 2
// node-id: 3933-44772 (group), 3933-44623 (item states)
// Размеры: small (36pt) / xxSmall (24pt)
// Состояния: default / active / disabled
// Поддержка: text, icon-left, icon-right, icon-only

import SwiftUI

// MARK: - DSButtonGroupItem Model

struct DSButtonGroupItem: Identifiable {
    let id: String
    var title: String? = nil
    var iconLeading: String? = nil
    var iconTrailing: String? = nil
    var isDisabled: Bool = false

    // Icon-only convenience
    init(id: String, icon: String, isDisabled: Bool = false) {
        self.id = id
        self.iconLeading = icon
        self.isDisabled = isDisabled
    }

    // Text-only convenience
    init(id: String, title: String, isDisabled: Bool = false) {
        self.id = id
        self.title = title
        self.isDisabled = isDisabled
    }

    // Full
    init(
        id: String,
        title: String? = nil,
        iconLeading: String? = nil,
        iconTrailing: String? = nil,
        isDisabled: Bool = false
    ) {
        self.id = id
        self.title = title
        self.iconLeading = iconLeading
        self.iconTrailing = iconTrailing
        self.isDisabled = isDisabled
    }
}

// MARK: - DSButtonGroup

struct DSButtonGroup: View {

    // MARK: - Types

    enum GroupSize {
        case small      // height 36pt, px-16, icon 20pt, font paragraphSm (14pt)
        case xxSmall    // height 24pt, px-10, icon 16pt, font paragraphXS (12pt)
    }

    // MARK: - Properties

    var items: [DSButtonGroupItem]
    var selectedId: String? = nil
    var size: GroupSize = .small
    var onSelect: ((String) -> Void)? = nil

    // MARK: - Computed

    private var itemHeight: CGFloat { size == .small ? 36 : 24 }
    private var itemPadding: CGFloat { size == .small ? 16 : 10 }
    private var iconSize: CGFloat  { size == .small ? 20 : 16 }
    private var font: DSFont       { size == .small ? DS.Typography.paragraphSm : DS.Typography.paragraphXS }

    // MARK: - Body

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                itemView(item: item, index: index)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(RoundedRectangle(cornerRadius: size == .small ? DS.Radius.xs : 6))
        .overlay(
            RoundedRectangle(cornerRadius: size == .small ? DS.Radius.xs : 6)
                .strokeBorder(DS.Color.strokeSoft, lineWidth: 1)
        )
    }

    // MARK: - Item View

    @ViewBuilder
    private func itemView(item: DSButtonGroupItem, index: Int) -> some View {
        let isActive   = selectedId == item.id
        let isDisabled = item.isDisabled
        let isLast     = index == items.count - 1

        Button {
            if !isDisabled { onSelect?(item.id) }
        } label: {
            HStack(spacing: DS.Spacing.xs) {
                if let icon = item.iconLeading {
                    Image(systemName: icon)
                        .font(.system(size: iconSize))
                }
                if let title = item.title {
                    Text(title)
                        .dsFont(font)
                }
                if let icon = item.iconTrailing {
                    Image(systemName: icon)
                        .font(.system(size: iconSize))
                }
            }
            .foregroundStyle(itemForeground(isActive: isActive, isDisabled: isDisabled))
            .frame(height: itemHeight)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, itemPadding)
            .background(itemBackground(isActive: isActive, isDisabled: isDisabled))
            // Right-side divider (except last item)
            .overlay(alignment: .trailing) {
                if !isLast {
                    Rectangle()
                        .fill(DS.Color.strokeSoft)
                        .frame(width: 1)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    // MARK: - Helpers

    private func itemBackground(isActive: Bool, isDisabled: Bool) -> Color {
        if isDisabled || !isActive { return DS.Color.bgWhite }
        return DS.Color.bgWeak
    }

    private func itemForeground(isActive: Bool, isDisabled: Bool) -> Color {
        if isDisabled { return DS.Color.textDisabled }
        if isActive   { return DS.Color.textMain }
        return DS.Color.textSub
    }
}

// MARK: - Convenience: String-based (simple segmented control)

extension DSButtonGroup {
    /// Упрощённый инициализатор: массив строк → автоматически формирует items
    init(
        titles: [String],
        selectedIndex: Binding<Int>,
        size: GroupSize = .small
    ) {
        let items = titles.enumerated().map { i, t in
            DSButtonGroupItem(id: "\(i)", title: t)
        }
        self.items = items
        self.selectedId = "\(selectedIndex.wrappedValue)"
        self.size = size
        self.onSelect = { id in
            if let i = Int(id) { selectedIndex.wrappedValue = i }
        }
    }
}

// MARK: - Preview

#Preview("DSButtonGroup — все варианты") {
    struct PreviewWrapper: View {
        @State private var seg1 = 0
        @State private var seg2 = 1
        @State private var seg3: String? = "week"

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s24) {

                    sectionHeader("Small — текст")
                    DSButtonGroup(
                        titles: ["День", "Неделя", "Месяц"],
                        selectedIndex: $seg1,
                        size: .small
                    )

                    sectionHeader("Small — иконки + текст")
                    DSButtonGroup(
                        items: [
                            DSButtonGroupItem(id: "list",  title: "Список",  iconLeading: "list.bullet"),
                            DSButtonGroupItem(id: "grid",  title: "Сетка",   iconLeading: "square.grid.2x2"),
                            DSButtonGroupItem(id: "chart", title: "График",  iconLeading: "chart.bar"),
                        ],
                        selectedId: "list",
                        size: .small,
                        onSelect: { _ in }
                    )

                    sectionHeader("Small — только иконки")
                    DSButtonGroup(
                        items: [
                            DSButtonGroupItem(id: "bold",   icon: "bold"),
                            DSButtonGroupItem(id: "italic", icon: "italic"),
                            DSButtonGroupItem(id: "under",  icon: "underline"),
                            DSButtonGroupItem(id: "strike", icon: "strikethrough"),
                        ],
                        selectedId: "bold",
                        size: .small,
                        onSelect: { _ in }
                    )

                    sectionHeader("2XSmall — текст")
                    DSButtonGroup(
                        titles: ["1D", "1W", "1M", "3M", "1Y"],
                        selectedIndex: $seg2,
                        size: .xxSmall
                    )

                    sectionHeader("С disabled элементом")
                    DSButtonGroup(
                        items: [
                            DSButtonGroupItem(id: "all",    title: "Все"),
                            DSButtonGroupItem(id: "active", title: "Активные"),
                            DSButtonGroupItem(id: "closed", title: "Закрытые", isDisabled: true),
                        ],
                        selectedId: "all",
                        size: .small,
                        onSelect: { _ in }
                    )

                    sectionHeader("Интерактивный")
                    VStack(alignment: .leading, spacing: DS.Spacing.s8) {
                        DSButtonGroup(
                            items: [
                                DSButtonGroupItem(id: "day",   title: "День"),
                                DSButtonGroupItem(id: "week",  title: "Неделя"),
                                DSButtonGroupItem(id: "month", title: "Месяц"),
                                DSButtonGroupItem(id: "year",  title: "Год"),
                            ],
                            selectedId: seg3,
                            size: .small,
                            onSelect: { seg3 = $0 }
                        )
                        Text("Выбрано: \(seg3 ?? "—")")
                            .dsFont(DS.Typography.paragraphXS)
                            .foregroundStyle(DS.Color.textSoft)
                    }
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
