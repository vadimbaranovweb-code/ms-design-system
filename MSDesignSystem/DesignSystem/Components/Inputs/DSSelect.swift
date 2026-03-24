// DSSelect.swift
// DesignSystem/Components/Inputs/DSSelect.swift
//
// Поле выбора (select) — открывает DSBottomSheet со списком и опциональным поиском.
// Используется для выбора языка, страны и других списков.

import SwiftUI

// MARK: - DSSelectOption

struct DSSelectOption: Identifiable, Equatable {
    let id: String
    let title: String
    let subtitle: String?
    let iconName: String?   // SF Symbol или Asset name
    let emoji: String?      // Флаг страны / эмодзи

    init(
        id: String,
        title: String,
        subtitle: String? = nil,
        iconName: String? = nil,
        emoji: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.iconName = iconName
        self.emoji = emoji
    }
}

// MARK: - DSSelect

struct DSSelect: View {

    // MARK: Config
    let label: String?
    let placeholder: String
    let options: [DSSelectOption]
    let isSearchable: Bool
    let isRequired: Bool
    let isDisabled: Bool
    let errorMessage: String?
    let hint: String?

    @Binding var selection: DSSelectOption?

    // MARK: State
    @State private var isSheetPresented = false
    @State private var searchQuery = ""

    init(
        label: String? = nil,
        placeholder: String = "Выберите...",
        options: [DSSelectOption],
        selection: Binding<DSSelectOption?>,
        isSearchable: Bool = false,
        isRequired: Bool = false,
        isDisabled: Bool = false,
        errorMessage: String? = nil,
        hint: String? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self.options = options
        self._selection = selection
        self.isSearchable = isSearchable
        self.isRequired = isRequired
        self.isDisabled = isDisabled
        self.errorMessage = errorMessage
        self.hint = hint
    }

    // MARK: Computed

    private var hasError: Bool { errorMessage != nil }

    private var borderColor: Color {
        if hasError { return DS.Color.error }
        return DS.Color.strokeSoft
    }

    private var filteredOptions: [DSSelectOption] {
        guard isSearchable, !searchQuery.isEmpty else { return options }
        return options.filter {
            $0.title.localizedCaseInsensitiveContains(searchQuery) ||
            ($0.subtitle?.localizedCaseInsensitiveContains(searchQuery) ?? false)
        }
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: DS.Spacing.s8) {
            labelRow
            trigger
            if let errorMessage {
                errorRow(errorMessage)
            } else if let hint {
                hintRow(hint)
            }
        }
        .overlay(alignment: .bottom) {
            DSBottomSheet(
                isPresented: $isSheetPresented,
                title: label,
                showHandle: true
            ) {
                sheetBody
            }
        }
    }

    // MARK: - Label Row

    @ViewBuilder
    private var labelRow: some View {
        if let label {
            HStack(spacing: DS.Spacing.xs) {
                Text(label)
                    .dsFont(DS.Typography.labelSm)
                    .foregroundStyle(DS.Color.textSub)
                if isRequired {
                    Text("*")
                        .dsFont(DS.Typography.labelSm)
                        .foregroundStyle(DS.Color.error)
                }
            }
        }
    }

    // MARK: - Trigger Button

    private var trigger: some View {
        Button {
            guard !isDisabled else { return }
            isSheetPresented = true
        } label: {
            HStack(spacing: DS.Spacing.s8) {
                // Leading: emoji / icon
                if let selected = selection {
                    if let emoji = selected.emoji {
                        Text(emoji).font(.system(size: 18))
                    } else if let icon = selected.iconName {
                        Image(systemName: icon)
                            .font(.system(size: 16))
                            .foregroundStyle(DS.Color.textSub)
                    }
                }

                // Title / Placeholder
                Text(selection?.title ?? placeholder)
                    .dsFont(DS.Typography.paragraphMd)
                    .foregroundStyle(selection != nil ? DS.Color.textMain : DS.Color.textSoft)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Chevron
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(DS.Color.textSoft)
                    .rotationEffect(.degrees(isSheetPresented ? 180 : 0))
                    .animation(DS.Animation.fast, value: isSheetPresented)
            }
            .padding(.horizontal, DS.Spacing.s12)
            .frame(height: 44)
            .background(isDisabled ? DS.Color.bgWeak : DS.Color.bgWhite)
            .overlay(
                RoundedRectangle(cornerRadius: DS.Radius.md)
                    .stroke(borderColor, lineWidth: 1)
            )
            .cornerRadius(DS.Radius.md)
        }
        .disabled(isDisabled)
    }

    // MARK: - Error / Hint

    private func errorRow(_ message: String) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 12))
                .foregroundStyle(DS.Color.error)
            Text(message)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(DS.Color.error)
        }
    }

    private func hintRow(_ text: String) -> some View {
        HStack(spacing: DS.Spacing.xs) {
            Image(systemName: "info.circle")
                .font(.system(size: 12))
                .foregroundStyle(DS.Color.textSoft)
            Text(text)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(DS.Color.textSoft)
        }
    }

    // MARK: - Sheet Body

    private var sheetBody: some View {
        VStack(spacing: 0) {
            // Search field
            if isSearchable {
                HStack(spacing: DS.Spacing.s8) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundStyle(DS.Color.textSoft)
                    TextField("Поиск...", text: $searchQuery)
                        .dsFont(DS.Typography.paragraphMd)
                        .foregroundStyle(DS.Color.textMain)
                        .autocorrectionDisabled()
                }
                .padding(.horizontal, DS.Spacing.s12)
                .frame(height: 40)
                .background(DS.Color.bgWeak)
                .cornerRadius(DS.Radius.xs)
                .padding(.horizontal, DS.Spacing.md)
                .padding(.bottom, DS.Spacing.s12)
            }

            // Options list
            ScrollView {
                LazyVStack(spacing: 0) {
                    if filteredOptions.isEmpty {
                        Text("Ничего не найдено")
                            .dsFont(DS.Typography.paragraphMd)
                            .foregroundStyle(DS.Color.textSoft)
                            .padding(.vertical, DS.Spacing.xl)
                            .frame(maxWidth: .infinity)
                    } else {
                        ForEach(filteredOptions) { option in
                            optionRow(option)
                        }
                    }
                }
            }
            .frame(maxHeight: 320)

            // Bottom safe area
            Spacer().frame(height: DS.Spacing.xxl)
        }
    }

    // MARK: - Option Row

    private func optionRow(_ option: DSSelectOption) -> some View {
        let isSelected = selection?.id == option.id
        return Button {
            selection = option
            searchQuery = ""
            isSheetPresented = false
        } label: {
            HStack(spacing: DS.Spacing.s12) {
                // Leading: emoji / icon
                if let emoji = option.emoji {
                    Text(emoji).font(.system(size: 22))
                        .frame(width: 28)
                } else if let icon = option.iconName {
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundStyle(DS.Color.textSub)
                        .frame(width: 28)
                }

                // Titles
                VStack(alignment: .leading, spacing: 2) {
                    Text(option.title)
                        .dsFont(DS.Typography.paragraphMd)
                        .foregroundStyle(isSelected ? DS.Color.brandPrimary : DS.Color.textMain)
                    if let subtitle = option.subtitle {
                        Text(subtitle)
                            .dsFont(DS.Typography.paragraphXS)
                            .foregroundStyle(DS.Color.textSoft)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Checkmark
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(DS.Color.brandPrimary)
                }
            }
            .padding(.horizontal, DS.Spacing.md)
            .frame(height: option.subtitle != nil ? 56 : 48)
            .background(isSelected ? DS.Color.brandPrimaryLighter : DS.Color.bgWhite)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview("DSSelect") {
    struct PreviewWrapper: View {
        @State private var language: DSSelectOption? = nil
        @State private var country: DSSelectOption? = nil

        let languages: [DSSelectOption] = [
            DSSelectOption(id: "ru", title: "Русский", emoji: "🇷🇺"),
            DSSelectOption(id: "en", title: "English", subtitle: "English (US)", emoji: "🇺🇸"),
            DSSelectOption(id: "es", title: "Español", emoji: "🇪🇸"),
            DSSelectOption(id: "de", title: "Deutsch", emoji: "🇩🇪"),
            DSSelectOption(id: "fr", title: "Français", emoji: "🇫🇷"),
            DSSelectOption(id: "zh", title: "中文", subtitle: "Chinese Simplified", emoji: "🇨🇳"),
        ]

        let countries: [DSSelectOption] = [
            DSSelectOption(id: "1", title: "Россия", iconName: "globe"),
            DSSelectOption(id: "2", title: "США", iconName: "globe"),
            DSSelectOption(id: "3", title: "Германия", iconName: "globe"),
        ]

        var body: some View {
            ScrollView {
                VStack(spacing: DS.Spacing.lg) {
                    DSSelect(
                        label: "Язык",
                        placeholder: "Выберите язык",
                        options: languages,
                        selection: $language,
                        isSearchable: true,
                        isRequired: true,
                        hint: "Язык интерфейса приложения"
                    )

                    DSSelect(
                        label: "Страна",
                        placeholder: "Выберите страну",
                        options: countries,
                        selection: $country
                    )

                    DSSelect(
                        label: "Отключён",
                        placeholder: "Недоступно",
                        options: languages,
                        selection: .constant(nil),
                        isDisabled: true
                    )

                    DSSelect(
                        label: "Ошибка",
                        placeholder: "Выберите...",
                        options: languages,
                        selection: .constant(nil),
                        errorMessage: "Поле обязательно для заполнения"
                    )
                }
                .padding(DS.Spacing.md)
            }
            .background(DS.Color.bgWeak)
        }
    }
    return PreviewWrapper()
}
