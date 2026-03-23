// DSAlert.swift
// DesignSystem/Components/Feedback/DSAlert.swift
//
// Из Figma — MS Design System 2
// node-id: 3833:42072
// Alert / Notification / Toast
// Status: error / warning / success / information / feature
// Style: filled / lighter
// Size: compact (32pt) / large

import SwiftUI

// MARK: - DSAlert

struct DSAlert: View {

    // MARK: - Types

    enum AlertStatus {
        case error, warning, success, information, feature

        var icon: String {
            switch self {
            case .error:       return "exclamationmark.circle.fill"
            case .warning:     return "exclamationmark.triangle.fill"
            case .success:     return "checkmark.circle.fill"
            case .information: return "info.circle.fill"
            case .feature:     return "sparkles"
            }
        }
    }

    enum AlertStyle { case filled, lighter }
    enum AlertSize  { case compact, large }

    // MARK: - Properties

    var status: AlertStatus = .error
    var style: AlertStyle = .filled
    var size: AlertSize = .large
    var title: String
    var description: String? = nil        // только для large
    var showIcon: Bool = true
    var primaryAction: AlertAction? = nil
    var secondaryAction: AlertAction? = nil
    var onDismiss: (() -> Void)? = nil

    struct AlertAction {
        let title: String
        let action: () -> Void
    }

    // MARK: - Body

    var body: some View {
        switch size {
        case .compact: compactBody
        case .large:   largeBody
        }
    }

    // MARK: - Compact (32pt)

    private var compactBody: some View {
        HStack(spacing: DS.Spacing.s8) {
            if showIcon {
                Image(systemName: status.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(compactIconColor)
            }

            Text(title)
                .dsFont(DS.Typography.paragraphXS)
                .foregroundStyle(compactTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let primary = primaryAction {
                Button(action: primary.action) {
                    Text(primary.title)
                        .dsFont(DS.Typography.labelXS)
                        .foregroundStyle(compactTextColor)
                }
                .buttonStyle(.plain)
            }

            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(compactTextColor.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(DS.Spacing.s8)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xs))
    }

    // MARK: - Large

    private var largeBody: some View {
        HStack(alignment: .top, spacing: DS.Spacing.s12) {
            if showIcon {
                Image(systemName: status.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(largeIconColor)
            }

            VStack(alignment: .leading, spacing: 10) {
                // Text block
                VStack(alignment: .leading, spacing: DS.Spacing.xs) {
                    Text(title)
                        .dsFont(DS.Typography.labelSm)
                        .foregroundStyle(largeTextColor)

                    if let description {
                        Text(description)
                            .dsFont(DS.Typography.paragraphSm)
                            .foregroundStyle(largeTextColor.opacity(style == .filled ? 0.88 : 1))
                    }
                }

                // Actions
                if primaryAction != nil || secondaryAction != nil {
                    HStack(spacing: DS.Spacing.s8) {
                        if let primary = primaryAction {
                            Button(action: primary.action) {
                                Text(primary.title)
                                    .dsFont(DS.Typography.labelSm)
                                    .foregroundStyle(largeTextColor)
                                    .underline(style == .lighter)
                            }
                            .buttonStyle(.plain)
                        }

                        if primaryAction != nil && secondaryAction != nil {
                            Text("·")
                                .dsFont(DS.Typography.paragraphSm)
                                .foregroundStyle(largeTextColor.opacity(0.48))
                        }

                        if let secondary = secondaryAction {
                            Button(action: secondary.action) {
                                Text(secondary.title)
                                    .dsFont(DS.Typography.labelSm)
                                    .foregroundStyle(largeTextColor)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(largeTextColor.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 14)
        .padding(.bottom, 16)
        .background(bgColor)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.md))
    }

    // MARK: - Colors

    private var bgColor: Color {
        switch style {
        case .filled:
            switch status {
            case .error:       return DS.Color.error            // #DF1C41
            case .warning:     return DS.Color.warning          // #F17B2C
            case .success:     return DS.Color.success          // #38C793
            case .information: return DS.Color.brandPrimary     // #375DFB
            case .feature:     return DS.Color.neutralBase      // #20232D
            }
        case .lighter:
            switch status {
            case .error:       return DS.Color.errorLighter     // #FDEDF0
            case .warning:     return DS.Color.warningLighter   // #FEF3EB
            case .success:     return DS.Color.successLighter   // #EFFAF6
            case .information: return DS.Color.brandPrimaryLighter // #EBF1FF
            case .feature:     return DS.Color.bgWeak           // #F6F8FA
            }
        }
    }

    // Compact icon (=text color в filled, status color в lighter)
    private var compactIconColor: Color {
        style == .filled ? DS.Color.textWhite : lighterIconColor
    }

    private var compactTextColor: Color {
        style == .filled ? DS.Color.textWhite : DS.Color.textMain
    }

    private var largeIconColor: Color {
        style == .filled ? DS.Color.textWhite : lighterIconColor
    }

    private var largeTextColor: Color {
        style == .filled ? DS.Color.textWhite : DS.Color.textMain
    }

    private var lighterIconColor: Color {
        switch status {
        case .error:       return DS.Color.error
        case .warning:     return DS.Color.warning
        case .success:     return DS.Color.success
        case .information: return DS.Color.brandPrimary
        case .feature:     return DS.Color.textMain
        }
    }
}

// MARK: - DSToast (временное уведомление с автоскрытием)

struct DSToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    var status: DSAlert.AlertStatus
    var style: DSAlert.AlertStyle
    var title: String
    var description: String? = nil
    var duration: TimeInterval = 3.0
    var position: VerticalAlignment = .bottom

    func body(content: Content) -> some View {
        content.overlay(alignment: position == .bottom ? .bottom : .top) {
            if isPresented {
                DSAlert(
                    status: status,
                    style: style,
                    size: description != nil ? .large : .compact,
                    title: title,
                    description: description,
                    onDismiss: { isPresented = false }
                )
                .padding(.horizontal, DS.Spacing.s16)
                .padding(position == .bottom ? .bottom : .top, DS.Spacing.s32)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: position == .bottom ? .bottom : .top).combined(with: .opacity),
                        removal: .move(edge: position == .bottom ? .bottom : .top).combined(with: .opacity)
                    )
                )
                .zIndex(999)
                .task {
                    try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
                    withAnimation(DS.Animation.standard) { isPresented = false }
                }
            }
        }
        .animation(DS.Animation.standard, value: isPresented)
    }
}

extension View {
    func dsToast(
        isPresented: Binding<Bool>,
        status: DSAlert.AlertStatus = .success,
        style: DSAlert.AlertStyle = .filled,
        title: String,
        description: String? = nil,
        duration: TimeInterval = 3.0,
        position: VerticalAlignment = .bottom
    ) -> some View {
        modifier(DSToastModifier(
            isPresented: isPresented,
            status: status,
            style: style,
            title: title,
            description: description,
            duration: duration,
            position: position
        ))
    }
}

// MARK: - Preview

#Preview("DSAlert — все варианты") {
    struct PreviewWrapper: View {
        @State private var showToast = false

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: DS.Spacing.s16) {

                    // Compact — Filled
                    sectionHeader("Compact — Filled")
                    DSAlert(status: .error,       style: .filled, size: .compact, title: "Ошибка оплаты", onDismiss: {})
                    DSAlert(status: .warning,     style: .filled, size: .compact, title: "Проверьте данные", onDismiss: {})
                    DSAlert(status: .success,     style: .filled, size: .compact, title: "Сохранено!", onDismiss: {})
                    DSAlert(status: .information, style: .filled, size: .compact, title: "Новая версия доступна",
                            primaryAction: .init(title: "Обновить", action: {}), onDismiss: {})
                    DSAlert(status: .feature,     style: .filled, size: .compact, title: "Новая функция", onDismiss: {})

                    // Compact — Lighter
                    sectionHeader("Compact — Lighter")
                    DSAlert(status: .error,       style: .lighter, size: .compact, title: "Ошибка оплаты", onDismiss: {})
                    DSAlert(status: .warning,     style: .lighter, size: .compact, title: "Проверьте данные", onDismiss: {})
                    DSAlert(status: .success,     style: .lighter, size: .compact, title: "Сохранено!", onDismiss: {})
                    DSAlert(status: .information, style: .lighter, size: .compact, title: "Новая версия", onDismiss: {})
                    DSAlert(status: .feature,     style: .lighter, size: .compact, title: "Новая функция", onDismiss: {})

                    // Large — Filled
                    sectionHeader("Large — Filled")
                    ForEach([DSAlert.AlertStatus.error, .warning, .success, .information, .feature], id: \.icon) { s in
                        DSAlert(
                            status: s,
                            style: .filled,
                            size: .large,
                            title: "Insert your alert title here!",
                            description: "Insert the alert description here. It would look better as two lines of text.",
                            primaryAction: .init(title: "Upgrade", action: {}),
                            secondaryAction: .init(title: "Learn more", action: {}),
                            onDismiss: {}
                        )
                    }

                    // Large — Lighter
                    sectionHeader("Large — Lighter")
                    ForEach([DSAlert.AlertStatus.error, .warning, .success, .information, .feature], id: \.icon) { s in
                        DSAlert(
                            status: s,
                            style: .lighter,
                            size: .large,
                            title: "Insert your alert title here!",
                            description: "Insert the alert description here. It would look better as two lines of text.",
                            primaryAction: .init(title: "Upgrade", action: {}),
                            secondaryAction: .init(title: "Learn more", action: {}),
                            onDismiss: {}
                        )
                    }

                    // Toast
                    sectionHeader(".dsToast() modifier")
                    DSButton("Показать Toast", action: { showToast = true })
                }
                .padding(DS.Spacing.s16)
            }
            .background(DS.Color.bgWeak)
            .dsToast(isPresented: $showToast, status: .success, title: "Данные сохранены!")
        }
    }
    return PreviewWrapper()
}

private func sectionHeader(_ text: String) -> some View {
    Text(text.uppercased())
        .dsFont(DS.Typography.subheadingXS)
        .foregroundStyle(DS.Color.textSoft)
}
