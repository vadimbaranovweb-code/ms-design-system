// ComponentsGallery.swift
// DesignSystem/ComponentsGallery.swift
//
// Каталог всех компонентов дизайн-системы для быстрого просмотра в Xcode Preview.
// Открой этот файл в Xcode → нажми Resume в Canvas.

import SwiftUI

// MARK: - Root Gallery

struct ComponentsGallery: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Actions") { ActionsSection() }
                NavigationLink("Inputs") { InputsSection() }
                NavigationLink("Controls") { ControlsSection() }
                NavigationLink("Badges & Tags") { BadgesSection() }
                NavigationLink("Feedback") { FeedbackSection() }
                NavigationLink("Layout") { LayoutSection() }
                NavigationLink("Media") { MediaSection() }
            }
            .navigationTitle("DS Components")
        }
    }
}

// MARK: - Tokens Preview

private struct TokensRow: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: DS.Spacing.s8) {
                ForEach([
                    (DS.Color.brandPrimary,   "Primary"),
                    (DS.Color.success,        "Success"),
                    (DS.Color.warning,        "Warning"),
                    (DS.Color.error,          "Error"),
                    (DS.Color.bgWeak,         "bgWeak"),
                    (DS.Color.bgSurface,      "bgSurface"),
                ], id: \.1) { color, name in
                    VStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(color)
                            .frame(width: 48, height: 48)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(DS.Color.strokeSoft, lineWidth: 1))
                        Text(name)
                            .dsFont(DS.Typography.paragraphXS)
                            .foregroundStyle(DS.Color.textSub)
                    }
                }
            }
            .padding(.horizontal, DS.Spacing.md)
        }
    }
}

// MARK: - Actions

private struct ActionsSection: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("Styles")
                VStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Primary", style: .primary) {}
                    DSButton(title: "Secondary", style: .secondary) {}
                    DSButton(title: "Danger", style: .danger) {}
                    DSButton(title: "Ghost", style: .ghost) {}
                    DSButton(title: "Link", style: .link) {}
                }

                sectionHeader("Sizes")
                HStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "XSmall", style: .primary, size: .xSmall) {}
                    DSButton(title: "Small", style: .primary, size: .small) {}
                    DSButton(title: "Medium", style: .primary, size: .medium) {}
                }

                sectionHeader("States")
                VStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Loading", style: .primary, isLoading: true) {}
                    DSButton(title: "Disabled", style: .primary, isDisabled: true) {}
                    DSButton(title: "Full Width", style: .primary, isFullWidth: true) {}
                }
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Actions")
    }
}

// MARK: - Inputs

private struct InputsSection: View {
    @State private var text1 = ""
    @State private var text2 = "Filled value"
    @State private var area = ""
    @State private var selection: DSSelectOption? = nil

    let languages: [DSSelectOption] = [
        DSSelectOption(id: "ru", title: "Русский", emoji: "🇷🇺"),
        DSSelectOption(id: "en", title: "English", emoji: "🇺🇸"),
        DSSelectOption(id: "es", title: "Español", emoji: "🇪🇸"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSInputField")
                DSInputField(text: $text1, label: "Default", placeholder: "Enter text...")
                DSInputField(text: $text2, label: "Filled", placeholder: "")
                DSInputField(text: .constant(""), label: "Error", placeholder: "...", errorMessage: "Required field")
                DSInputField(text: .constant(""), label: "Disabled", placeholder: "...", isDisabled: true)

                sectionHeader("DSTextArea")
                DSTextArea(text: $area, label: "Comment", placeholder: "Write something...", maxCharacters: 200)

                sectionHeader("DSSelect")
                DSSelect(
                    label: "Language",
                    placeholder: "Choose language",
                    options: languages,
                    selection: $selection,
                    isSearchable: true
                )
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Inputs")
    }
}

// MARK: - Controls

private struct ControlsSection: View {
    @State private var checked = false
    @State private var indeterminate = true
    @State private var toggled = false
    @State private var switchIndex = 0
    @State private var radioSelection = "a"
    @State private var sliderValue: Double = 0.4
    @State private var groupSelection = "left"

    let switchTabs = [DSSwitchTab("Day"), DSSwitchTab("Week"), DSSwitchTab("Month")]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSCheckbox")
                HStack(spacing: DS.Spacing.md) {
                    DSCheckbox(isChecked: $checked, label: "Check me")
                    DSCheckbox(isChecked: $indeterminate, isIndeterminate: true, label: "Mixed")
                    DSCheckbox(isChecked: .constant(false), isDisabled: true, label: "Disabled")
                }

                sectionHeader("DSToggle")
                HStack(spacing: DS.Spacing.md) {
                    DSToggle(isOn: $toggled)
                    DSToggle(isOn: .constant(true))
                    DSToggle(isOn: .constant(false), isDisabled: true)
                }

                sectionHeader("DSSwitchToggle")
                DSSwitchToggle(selectedIndex: $switchIndex, tabs: switchTabs)

                sectionHeader("DSRadioGroup")
                DSRadioGroup(
                    selection: $radioSelection,
                    options: [
                        .init(value: "a", label: "Option A"),
                        .init(value: "b", label: "Option B"),
                        .init(value: "c", label: "Option C"),
                    ]
                )

                sectionHeader("DSButtonGroup")
                DSButtonGroup(
                    items: [
                        DSButtonGroupItem(id: "left",   title: "Left"),
                        DSButtonGroupItem(id: "center", title: "Center"),
                        DSButtonGroupItem(id: "right",  title: "Right"),
                    ],
                    selectedId: $groupSelection
                )

                sectionHeader("DSSlider")
                DSSlider(value: $sliderValue, label: "Volume", sublabel: "Max 100%", showTooltip: true)
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Controls")
    }
}

// MARK: - Badges & Tags

private struct BadgesSection: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSBadge")
                HStack(spacing: DS.Spacing.s8) {
                    DSBadge(text: "New")
                    DSBadge(text: "5")
                    DSBadge(text: "Pro", type: .success)
                    DSBadge(text: "Beta", type: .warning)
                    DSBadge(text: "Error", type: .error)
                }

                sectionHeader("DSTag — Filled")
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary",   variant: .filled(.primary))
                    DSTag("Success",   variant: .filled(.success))
                    DSTag("Warning",   variant: .filled(.warning))
                    DSTag("Error",     variant: .filled(.error))
                }

                sectionHeader("DSTag — Lighter")
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary",   variant: .lighter(.primary))
                    DSTag("Secondary", variant: .lighter(.secondary))
                    DSTag("Success",   variant: .lighter(.success))
                    DSTag("Neutral",   variant: .lighter(.neutral))
                }

                sectionHeader("DSTag — with icon / dot")
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Verified", variant: .lighter(.success), iconLeading: "checkmark.seal.fill")
                    DSTag("Online",   variant: .lighter(.success), showDot: true)
                    DSTag("Swift",    variant: .lighter(.primary),  onRemove: {})
                }

                sectionHeader("DSTagGroup (flow layout)")
                DSTagGroup(
                    ["SwiftUI", "Xcode", "Figma", "AlignUI", "Design System", "iOS", "Swift"],
                    variant: .lighter(.primary)
                )
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Badges & Tags")
    }
}

// MARK: - Feedback

private struct FeedbackSection: View {
    @State private var showToast   = false
    @State private var showModal   = false
    @State private var showTooltip = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSAlert — Compact")
                VStack(spacing: DS.Spacing.s8) {
                    DSAlert(status: .success, style: .filled, size: .compact, title: "Saved successfully")
                    DSAlert(status: .error,   style: .filled, size: .compact, title: "Something went wrong")
                    DSAlert(status: .warning, style: .lighter, size: .compact, title: "Check your input")
                    DSAlert(status: .information, style: .lighter, size: .compact, title: "FYI update")
                }

                sectionHeader("DSProgressBar")
                VStack(spacing: DS.Spacing.s12) {
                    DSProgressBar(progress: 0.3)
                    DSProgressBar(progress: 0.7, color: DS.Color.success)
                    DSStepProgressBar(totalSteps: 5, currentStep: 3)
                }

                sectionHeader("DSTooltip")
                HStack {
                    Text("Hover target")
                        .dsFont(DS.Typography.paragraphMd)
                        .foregroundStyle(DS.Color.textMain)
                        .dsTooltip(
                            isVisible: $showTooltip,
                            text: "This is a tooltip",
                            size: .xSmall,
                            theme: .dark,
                            tailPosition: .bottomCenter
                        )
                        .onTapGesture { showTooltip.toggle() }
                    Spacer()
                }

                sectionHeader("DSStatusModal / Toast")
                HStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Show Modal", style: .primary, size: .small) {
                        showModal = true
                    }
                    DSButton(title: "Show Toast", style: .secondary, size: .small) {
                        showToast = true
                    }
                }
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Feedback")
        .dsToast(isPresented: $showToast, status: .success, title: "Action completed")
        .dsStatusModal(
            isPresented: $showModal,
            type: .success,
            title: "Done!",
            description: "Your action was completed successfully.",
            primaryTitle: "OK",
            primaryAction: { showModal = false }
        )
    }
}

// MARK: - Layout

private struct LayoutSection: View {
    @State private var showSheet = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSCard")
                DSCard(style: .elevated, title: "Elevated Card", subtitle: "Shadow variant") {
                    Text("Content goes here").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
                }
                DSCard(style: .outlined, title: "Outlined Card") {
                    Text("Border variant").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
                }
                DSCard(style: .surface) {
                    Text("Surface (bgWeak)").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
                }

                sectionHeader("DSDivider")
                DSDivider(type: .line)
                DSDivider(type: .textLine("OR"))
                DSDivider(type: .textButton(title: "See all", action: {}))

                sectionHeader("DSBottomSheet")
                DSButton(title: "Open Bottom Sheet", style: .secondary) {
                    showSheet = true
                }
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Layout")
        .dsBottomSheet(isPresented: $showSheet, title: "Bottom Sheet") {
            VStack(spacing: 0) {
                ForEach(["Option A", "Option B", "Option C"], id: \.self) { item in
                    HStack {
                        Text(item).dsFont(DS.Typography.paragraphMd).foregroundStyle(DS.Color.textMain)
                        Spacer()
                    }
                    .padding(.horizontal, DS.Spacing.md)
                    .frame(height: 48)
                    Divider().padding(.horizontal, DS.Spacing.md)
                }
                Spacer().frame(height: DS.Spacing.xxl)
            }
        }
    }
}

// MARK: - Media

private struct MediaSection: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSAvatar — Sizes")
                HStack(spacing: DS.Spacing.md) {
                    DSAvatar(size: .xSmall,  initials: "AB")
                    DSAvatar(size: .small,   initials: "AB")
                    DSAvatar(size: .medium,  initials: "AB")
                    DSAvatar(size: .large,   initials: "AB")
                    DSAvatar(size: .xLarge,  initials: "AB")
                    DSAvatar(size: .xxLarge, initials: "AB")
                }

                sectionHeader("DSAvatar — States")
                HStack(spacing: DS.Spacing.md) {
                    DSAvatar(size: .large)
                    DSAvatar(size: .large, initials: "VM", status: .online)
                    DSAvatar(size: .large, initials: "VM", status: .busy)
                    DSAvatar(size: .large, initials: "VM", badgeCount: 5)
                }

                sectionHeader("DSAvatar — Rounded Square")
                HStack(spacing: DS.Spacing.md) {
                    DSAvatar(size: .medium, shape: .roundedSquare, initials: "MS")
                    DSAvatar(size: .large,  shape: .roundedSquare, initials: "MS")
                    DSAvatar(size: .xLarge, shape: .roundedSquare, initials: "MS")
                }

                sectionHeader("DSAvatarGroup")
                DSAvatarGroup(
                    avatars: [(nil, "AB"), (nil, "VM"), (nil, "JD"), (nil, "KL"), (nil, "MN"), (nil, "OP")],
                    size: .small,
                    maxVisible: 4
                )
            }
            .padding(DS.Spacing.md)
        }
        .background(DS.Color.bgWeak)
        .navigationTitle("Media")
    }
}

// MARK: - Helpers

private func sectionHeader(_ title: String) -> some View {
    Text(title)
        .dsFont(DS.Typography.labelXS)
        .foregroundStyle(DS.Color.textSoft)
        .textCase(.uppercase)
        .padding(.top, DS.Spacing.s4)
}

// MARK: - Preview

#Preview("Components Gallery") {
    ComponentsGallery()
}
