// DSTag.swift
// DesignSystem/Components/Badges/DSTag.swift
//
// Тег / Chip — компактная метка для категорий, фильтров, статусов.
// Размеры: small (24pt) / medium (28pt) / large (32pt)
// Варианты: filled, lighter, outline, ghost
// Опционально: иконка слева, иконка-закрыть справа, dot-индикатор

import SwiftUI

// MARK: - TagSize

enum DSTagSize {
    case small   // h=24, px=8, text=paragraphXS(12pt)
    case medium  // h=28, px=10, text=paragraphXS(12pt)
    case large   // h=32, px=12, text=labelSm(14pt)

    var height: CGFloat {
        switch self {
        case .small:  return 24
        case .medium: return 28
        case .large:  return 32
        }
    }

    var horizontalPadding: CGFloat {
        switch self {
        case .small:  return 8
        case .medium: return 10
        case .large:  return 12
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .small:  return 12
        case .medium: return 14
        case .large:  return 16
        }
    }

    var font: DSFont {
        switch self {
        case .small, .medium: return DS.Typography.paragraphXS
        case .large:          return DS.Typography.labelSm
        }
    }
}

// MARK: - TagVariant

enum DSTagVariant {
    case filled(DSTagColor)
    case lighter(DSTagColor)
    case outline(DSTagColor)
    case ghost

    var backgroundColor: Color {
        switch self {
        case .filled(let c):  return c.solidColor
        case .lighter(let c): return c.lightColor
        case .outline:        return .clear
        case .ghost:          return .clear
        }
    }

    var textColor: Color {
        switch self {
        case .filled:         return DS.Color.textWhite
        case .lighter(let c): return c.solidColor
        case .outline(let c): return c.solidColor
        case .ghost:          return DS.Color.textSub
        }
    }

    var borderColor: Color? {
        switch self {
        case .filled, .lighter, .ghost: return nil
        case .outline(let c):           return c.solidColor
        }
    }
}

// MARK: - TagColor

enum DSTagColor {
    case neutral
    case primary
    case secondary
    case success
    case warning
    case error
    case info

    var solidColor: Color {
        switch self {
        case .neutral:   return DS.Color.neutralBase
        case .primary:   return DS.Color.brandPrimary
        case .secondary: return DS.Color.brandSecondary
        case .success:   return DS.Color.success
        case .warning:   return DS.Color.warning
        case .error:     return DS.Color.error
        case .info:      return DS.Color.info
        }
    }

    var lightColor: Color {
        switch self {
        case .neutral:   return DS.Color.bgSurface
        case .primary:   return DS.Color.brandPrimaryLighter
        case .secondary: return DS.Color.brandSecondaryLighter
        case .success:   return DS.Color.successLighter
        case .warning:   return DS.Color.warningLighter
        case .error:     return DS.Color.errorLighter
        case .info:      return DS.Color.infoLighter
        }
    }
}

// MARK: - DSTag

struct DSTag: View {

    let title: String
    let size: DSTagSize
    let variant: DSTagVariant
    let iconLeading: String?   // SF Symbol
    let showDot: Bool
    let onRemove: (() -> Void)?  // nil = no close button
    let onTap: (() -> Void)?

    init(
        _ title: String,
        size: DSTagSize = .medium,
        variant: DSTagVariant = .lighter(.primary),
        iconLeading: String? = nil,
        showDot: Bool = false,
        onRemove: (() -> Void)? = nil,
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.size = size
        self.variant = variant
        self.iconLeading = iconLeading
        self.showDot = showDot
        self.onRemove = onRemove
        self.onTap = onTap
    }

    var body: some View {
        HStack(spacing: DS.Spacing.xs) {
            // Dot indicator
            if showDot {
                Circle()
                    .fill(variant.textColor)
                    .frame(width: 6, height: 6)
            }

            // Leading icon
            if let iconLeading {
                Image(systemName: iconLeading)
                    .font(.system(size: size.iconSize))
                    .foregroundStyle(variant.textColor)
            }

            // Title
            Text(title)
                .dsFont(size.font)
                .foregroundStyle(variant.textColor)
                .lineLimit(1)

            // Remove button
            if let onRemove {
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: size.iconSize - 2, weight: .medium))
                        .foregroundStyle(variant.textColor.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height)
        .background(variant.backgroundColor)
        .overlay(
            Capsule()
                .stroke(variant.borderColor ?? .clear, lineWidth: 1)
        )
        .clipShape(Capsule())
        .contentShape(Capsule())
        .onTapGesture { onTap?() }
    }
}

// MARK: - DSTagGroup (wrapping flow layout)

struct DSTagGroup: View {
    let tags: [String]
    let size: DSTagSize
    let variant: DSTagVariant
    let spacing: CGFloat

    init(
        _ tags: [String],
        size: DSTagSize = .medium,
        variant: DSTagVariant = .lighter(.primary),
        spacing: CGFloat = DS.Spacing.s8
    ) {
        self.tags = tags
        self.size = size
        self.variant = variant
        self.spacing = spacing
    }

    var body: some View {
        FlowLayout(spacing: spacing) {
            ForEach(tags, id: \.self) { tag in
                DSTag(tag, size: size, variant: variant)
            }
        }
    }
}

// MARK: - FlowLayout (wrapping HStack)

private struct FlowLayout: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.reduce(0) { $0 + $1.maxHeight } + CGFloat(max(0, rows.count - 1)) * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var y = bounds.minY
        for row in rows {
            var x = bounds.minX
            for subview in row.subviews {
                let size = subview.sizeThatFits(.unspecified)
                subview.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.maxHeight + spacing
        }
    }

    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()
        let maxWidth = proposal.width ?? .infinity

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentRow.width + size.width + (currentRow.subviews.isEmpty ? 0 : spacing) > maxWidth, !currentRow.subviews.isEmpty {
                rows.append(currentRow)
                currentRow = Row()
            }
            currentRow.add(subview: subview, size: size, spacing: spacing)
        }
        if !currentRow.subviews.isEmpty { rows.append(currentRow) }
        return rows
    }

    private struct Row {
        var subviews: [LayoutSubview] = []
        var width: CGFloat = 0
        var maxHeight: CGFloat = 0

        mutating func add(subview: LayoutSubview, size: CGSize, spacing: CGFloat) {
            if !subviews.isEmpty { width += spacing }
            subviews.append(subview)
            width += size.width
            maxHeight = max(maxHeight, size.height)
        }
    }
}

// MARK: - Preview

#Preview("DSTag") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {

            Group {
                Text("Sizes").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Small", size: .small)
                    DSTag("Medium", size: .medium)
                    DSTag("Large", size: .large)
                }
            }

            Group {
                Text("Filled").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary", variant: .filled(.primary))
                    DSTag("Success", variant: .filled(.success))
                    DSTag("Warning", variant: .filled(.warning))
                    DSTag("Error",   variant: .filled(.error))
                }
            }

            Group {
                Text("Lighter").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary",   variant: .lighter(.primary))
                    DSTag("Secondary", variant: .lighter(.secondary))
                    DSTag("Success",   variant: .lighter(.success))
                    DSTag("Neutral",   variant: .lighter(.neutral))
                }
            }

            Group {
                Text("Outline").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Primary", variant: .outline(.primary))
                    DSTag("Error",   variant: .outline(.error))
                    DSTag("Ghost",   variant: .ghost)
                }
            }

            Group {
                Text("With icon & dot").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("Verified",  variant: .lighter(.success), iconLeading: "checkmark.seal.fill")
                    DSTag("Online",    variant: .lighter(.success), showDot: true)
                    DSTag("New",       variant: .filled(.primary),  iconLeading: "star.fill")
                }
            }

            Group {
                Text("Removable chips").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                HStack(spacing: DS.Spacing.s8) {
                    DSTag("SwiftUI",    variant: .lighter(.primary), onRemove: {})
                    DSTag("Xcode",      variant: .lighter(.secondary), onRemove: {})
                    DSTag("Figma",      variant: .lighter(.neutral), onRemove: {})
                }
            }

            Group {
                Text("Tag Group (wrapping)").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
                DSTagGroup(
                    ["iOS", "Swift", "SwiftUI", "Xcode", "Figma", "Design System", "UI Kit", "AlignUI"],
                    variant: .lighter(.primary)
                )
            }
        }
        .padding(DS.Spacing.md)
    }
    .background(DS.Color.bgWeak)
}
