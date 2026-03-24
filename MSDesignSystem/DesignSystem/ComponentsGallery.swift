// ComponentsGallery.swift
// DesignSystem/ComponentsGallery.swift
//
// Каталог всех компонентов дизайн-системы для быстрого просмотра в Xcode Preview.
// Открой этот файл → нажми Resume в Canvas.

import SwiftUI

// MARK: - Root Gallery

struct ComponentsGallery: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Actions")      { ActionsSection() }
                NavigationLink("Inputs")       { InputsSection() }
                NavigationLink("Controls")     { ControlsSection() }
                NavigationLink("Badges & Tags") { BadgesSection() }
                NavigationLink("Feedback")     { FeedbackSection() }
                NavigationLink("Layout")       { LayoutSection() }
                NavigationLink("Media")        { MediaSection() }
            }
            .navigationTitle("DS Components")
        }
    }
}

// MARK: - Actions

private struct ActionsSection: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("Types × Styles")
                VStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Primary Filled",  type: .primary, style: .filled)  {}
                    DSButton(title: "Primary Stroke",  type: .primary, style: .stroke)  {}
                    DSButton(title: "Primary Lighter", type: .primary, style: .lighter) {}
                    DSButton(title: "Primary Ghost",   type: .primary, style: .ghost)   {}
                    DSButton(title: "Neutral Filled",  type: .neutral, style: .filled)  {}
                    DSButton(title: "Error Filled",    type: .error,   style: .filled)  {}
                    DSButton(title: "Error Stroke",    type: .error,   style: .stroke)  {}
                }

                sectionHeader("Sizes")
                HStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "XS",  type: .primary, style: .filled, size: .xSmall)  {}
                    DSButton(title: "SM",  type: .primary, style: .filled, size: .small)   {}
                    DSButton(title: "MD",  type: .primary, style: .filled, size: .medium)  {}
                }

                sectionHeader("States")
                VStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Disabled", type: .primary, style: .filled, isDisabled: true) {}
                    DSButton(title: "Full Width", type: .primary, style: .filled, isFullWidth: true) {}
                    DSButton(title: "With Icon", type: .primary, style: .filled, leftIcon: "star.fill") {}
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
    @State private var area  = ""
    @State private var selection: DSSelectOption? = nil

    let languages: [DSSelectOption] = [
        DSSelectOption(id: "ru", title: "Русский",  emoji: "🇷🇺"),
        DSSelectOption(id: "en", title: "English",  emoji: "🇺🇸"),
        DSSelectOption(id: "es", title: "Español",  emoji: "🇪🇸"),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSInputField")
                DSInputField("Placeholder default", text: $text1)
                DSInputField("With icon", text: $text2, leftIcon: "envelope", state: .default)
                DSInputField("Error state", text: .constant(""), state: .error)
                DSInputField("Disabled",    text: .constant(""), state: .disabled)

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
    @State private var checked      = false
    @State private var indeterminate = true
    @State private var toggled      = false
    @State private var switchIndex  = 0
    @State private var radioSel     = "a"
    @State private var sliderVal: Double = 0.4
    @State private var groupSel     = "left"

    let switchTabs = [DSSwitchTab("Day"), DSSwitchTab("Week"), DSSwitchTab("Month")]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSCheckbox")
                HStack(spacing: DS.Spacing.md) {
                    DSCheckbox(isChecked: $checked, label: "Check me")
                    DSCheckbox(isChecked: $indeterminate, isIndeterminate: true, label: "Mixed")
                    DSCheckbox(isChecked: .constant(false), isDisabled: true, label: "Off")
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
                    selection: $radioSel,
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
                    selectedId: $groupSel
                )

                sectionHeader("DSSlider")
                DSSlider(value: $sliderVal, label: "Volume", sublabel: "Max 100%", showTooltip: true)
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
                    DSBadge("New")
                    DSBadge("Pro",   color: .green)
                    DSBadge("Beta",  color: .orange)
                    DSBadge("Error", color: .red, style: .filled)
                    DSBadge("Info",  color: .blue)
                }

                sectionHeader("DSTag — Filled")
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary", variant: .filled(.primary))
                    DSTag("Success", variant: .filled(.success))
                    DSTag("Warning", variant: .filled(.warning))
                    DSTag("Error",   variant: .filled(.error))
                }

                sectionHeader("DSTag — Lighter")
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary",   variant: .lighter(.primary))
                    DSTag("Secondary", variant: .lighter(.secondary))
                    DSTag("Success",   variant: .lighter(.success))
                    DSTag("Neutral",   variant: .lighter(.neutral))
                }

                sectionHeader("DSTag — Icon / Dot / Removable")
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
    @State private var showToast  = false
    @State private var showModal  = false
    @State private var showTip    = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DS.Spacing.lg) {

                sectionHeader("DSAlert — Compact")
                VStack(spacing: DS.Spacing.s8) {
                    DSAlert(status: .success,     style: .filled,  size: .compact, title: "Saved")
                    DSAlert(status: .error,       style: .filled,  size: .compact, title: "Error occurred")
                    DSAlert(status: .warning,     style: .lighter, size: .compact, title: "Check input")
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
                    Text("Tap to toggle tooltip")
                        .dsFont(DS.Typography.paragraphMd)
                        .foregroundStyle(DS.Color.textMain)
                        .dsTooltip(isVisible: $showTip, text: "This is a tooltip", size: .xSmall, theme: .dark)
                        .onTapGesture { showTip.toggle() }
                    Spacer()
                }

                sectionHeader("Modal & Toast")
                HStack(spacing: DS.Spacing.s8) {
                    DSButton(title: "Modal", type: .primary, style: .filled, size: .small) {
                        showModal = true
                    }
                    DSButton(title: "Toast", type: .primary, style: .stroke, size: .small) {
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
            onPrimary: { showModal = false }
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
                DSCard(title: "Elevated Card", subtitle: "Shadow variant", style: .elevated) {
                    Text("Content here").dsFont(DS.Typography.paragraphSm).foregroundStyle(DS.Color.textSub)
                }
                DSCard(title: "Outlined Card", style: .outlined) {
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
                DSButton(title: "Open Bottom Sheet", type: .primary, style: .stroke) {
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
                    avatars: [(nil, "AB"), (nil, "VM"), (nil, "JD"), (nil, "KL"), (nil, "MN")],
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
