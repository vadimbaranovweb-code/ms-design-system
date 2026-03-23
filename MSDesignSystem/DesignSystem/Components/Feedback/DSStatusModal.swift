// DSStatusModal.swift
// DesignSystem/Components/Feedback/DSStatusModal.swift
//
// Из Figma — MS Design System 2
// node-id: 2484:71302
//
// Статусное модальное окно: success / error / warning / info
// Лейаут: default (кнопки рядом) / centered (кнопки стопкой)

import SwiftUI

// MARK: - DSStatusModal

struct DSStatusModal: View {

    // MARK: - Types

    enum ModalType {
        case success
        case error
        case warning
        case info

        var iconName: String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .error:   return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .info:    return "info.circle.fill"
            }
        }

        var iconColor: Color {
            switch self {
            case .success: return DS.Color.success
            case .error:   return DS.Color.error
            case .warning: return DS.Color.warning
            case .info:    return DS.Color.info
            }
        }

        var iconBg: Color {
            switch self {
            case .success: return DS.Color.successLighter
            case .error:   return DS.Color.errorLighter
            case .warning: return DS.Color.warningLighter
            case .info:    return DS.Color.infoLighter
            }
        }
    }

    enum ModalAlignment {
        /// Кнопки рядом: [Secondary] [Primary →]
        case `default`
        /// Кнопки стопкой: [Primary full-width] / [Secondary full-width]
        case centered
    }

    // MARK: - Properties

    var type: ModalType = .success
    var alignment: ModalAlignment = .default
    var title: String
    var description: String
    var primaryTitle: String = "Confirm"
    var secondaryTitle: String? = "Cancel"
    var onPrimary: () -> Void
    var onSecondary: (() -> Void)? = nil

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            // Content
            VStack(spacing: DS.Spacing.s16) {
                iconView
                textBlock
            }
            .padding(DS.Spacing.s20)

            // Footer
            Divider()
                .overlay(DS.Color.strokeSoft)
            footerView
                .padding(.horizontal, DS.Spacing.s20)
                .padding(.vertical, DS.Spacing.s16)
        }
        .background(DS.Color.bgWhite)
        .clipShape(RoundedRectangle(cornerRadius: DS.Radius.lg))
        // Figma: regular-shadow/medium
        .shadow(color: Color(hex: "#585C5F").opacity(0.10), radius: 32, x: 0, y: 16)
        .frame(maxWidth: 320)
    }

    // MARK: - Icon

    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: DS.Radius.sm)
                .fill(type.iconBg)
                .frame(width: 40, height: 40)
            Image(systemName: type.iconName)
                .font(.system(size: 24))
                .foregroundStyle(type.iconColor)
        }
    }

    // MARK: - Text

    private var textBlock: some View {
        VStack(spacing: DS.Spacing.xs) {
            Text(title)
                .dsFont(DS.Typography.labelMd)
                .foregroundStyle(DS.Color.textMain)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Text(description)
                .dsFont(DS.Typography.paragraphSm)
                .foregroundStyle(DS.Color.textSub)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Footer

    @ViewBuilder
    private var footerView: some View {
        switch alignment {
        case .default:
            // Кнопки рядом: Secondary | Primary
            HStack(spacing: DS.Spacing.s12) {
                if let secTitle = secondaryTitle {
                    footerButton(title: secTitle, isPrimary: false) {
                        onSecondary?()
                    }
                }
                footerButton(title: primaryTitle, isPrimary: true, action: onPrimary)
            }

        case .centered:
            // Кнопки стопкой: Primary сверху
            VStack(spacing: DS.Spacing.s8) {
                footerButton(title: primaryTitle, isPrimary: true, action: onPrimary)
                if let secTitle = secondaryTitle {
                    footerButton(title: secTitle, isPrimary: false) {
                        onSecondary?()
                    }
                }
            }
        }
    }

    private func footerButton(title: String, isPrimary: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .dsFont(DS.Typography.labelSm)
                .foregroundStyle(isPrimary ? DS.Color.textWhite : DS.Color.textSub)
                .frame(maxWidth: .infinity)
                .padding(.vertical, DS.Spacing.s8)
                .background(isPrimary ? DS.Color.brandPrimary : DS.Color.bgWhite)
                .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xs))
                .overlay(
                    RoundedRectangle(cornerRadius: DS.Radius.xs)
                        .strokeBorder(isPrimary ? Color.clear : DS.Color.strokeSoft, lineWidth: 1)
                )
                .shadow(
                    color: isPrimary
                        ? Color(hex: "#375DFB").opacity(0.08)
                        : Color(hex: "#525866").opacity(0.06),
                    radius: 2, x: 0, y: 1
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - ViewModifier для sheet-презентации

extension View {
    /// Показывает DSStatusModal как .sheet
    func dsStatusModal(
        isPresented: Binding<Bool>,
        type: DSStatusModal.ModalType = .success,
        alignment: DSStatusModal.ModalAlignment = .default,
        title: String,
        description: String,
        primaryTitle: String = "Confirm",
        secondaryTitle: String? = "Cancel",
        onPrimary: @escaping () -> Void = {},
        onSecondary: (() -> Void)? = nil
    ) -> some View {
        self.sheet(isPresented: isPresented) {
            DSStatusModal(
                type: type,
                alignment: alignment,
                title: title,
                description: description,
                primaryTitle: primaryTitle,
                secondaryTitle: secondaryTitle,
                onPrimary: {
                    isPresented.wrappedValue = false
                    onPrimary()
                },
                onSecondary: onSecondary.map { action in
                    { isPresented.wrappedValue = false; action() }
                }
            )
            .padding(DS.Spacing.s16)
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Preview

#Preview("DSStatusModal — все варианты") {
    ScrollView {
        VStack(spacing: DS.Spacing.s24) {

            Text("Default layout").dsFont(DS.Typography.subheadingXS)
                .foregroundStyle(DS.Color.textSoft)
                .frame(maxWidth: .infinity, alignment: .leading)

            DSStatusModal(
                type: .success,
                title: "Payment Successful",
                description: "Your payment has been processed. A confirmation has been sent to your email.",
                primaryTitle: "Done",
                secondaryTitle: "View Receipt",
                onPrimary: {}
            )

            DSStatusModal(
                type: .error,
                title: "Payment Failed",
                description: "Something went wrong with your payment. Please check your details and try again.",
                primaryTitle: "Try Again",
                secondaryTitle: "Cancel",
                onPrimary: {}
            )

            Text("Centered layout").dsFont(DS.Typography.subheadingXS)
                .foregroundStyle(DS.Color.textSoft)
                .frame(maxWidth: .infinity, alignment: .leading)

            DSStatusModal(
                type: .success,
                alignment: .centered,
                title: "Account Created!",
                description: "Welcome aboard. Your account is ready to use.",
                primaryTitle: "Get Started",
                secondaryTitle: "Learn More",
                onPrimary: {}
            )

            DSStatusModal(
                type: .warning,
                alignment: .centered,
                title: "Delete Account?",
                description: "This action is permanent and cannot be undone. All your data will be lost.",
                primaryTitle: "Delete",
                secondaryTitle: "Cancel",
                onPrimary: {}
            )

            DSStatusModal(
                type: .info,
                alignment: .centered,
                title: "New Version Available",
                description: "Update to get the latest features and bug fixes.",
                primaryTitle: "Update Now",
                secondaryTitle: "Later",
                onPrimary: {}
            )
        }
        .padding(DS.Spacing.s16)
    }
    .background(DS.Color.bgWeak)
}
