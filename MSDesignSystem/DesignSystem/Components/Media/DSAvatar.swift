// DSAvatar.swift
// DesignSystem/Components/Media/DSAvatar.swift
//
// Аватар пользователя — поддерживает фото, инициалы, иконку-заглушку.
// Размеры: xxSmall (20) / xSmall (24) / small (32) / medium (40) / large (48) / xLarge (64) / xxLarge (80)
// Опциональный badge статуса (online / offline / busy) и badge-счётчик.

import SwiftUI

// MARK: - AvatarSize

enum DSAvatarSize {
    case xxSmall  // 20pt
    case xSmall   // 24pt
    case small    // 32pt
    case medium   // 40pt
    case large    // 48pt
    case xLarge   // 64pt
    case xxLarge  // 80pt

    var dimension: CGFloat {
        switch self {
        case .xxSmall: return 20
        case .xSmall:  return 24
        case .small:   return 32
        case .medium:  return 40
        case .large:   return 48
        case .xLarge:  return 64
        case .xxLarge: return 80
        }
    }

    var fontSize: CGFloat {
        switch self {
        case .xxSmall: return 8
        case .xSmall:  return 10
        case .small:   return 12
        case .medium:  return 16
        case .large:   return 18
        case .xLarge:  return 24
        case .xxLarge: return 30
        }
    }

    var iconSize: CGFloat {
        switch self {
        case .xxSmall: return 10
        case .xSmall:  return 12
        case .small:   return 16
        case .medium:  return 20
        case .large:   return 24
        case .xLarge:  return 32
        case .xxLarge: return 40
        }
    }

    var statusDotSize: CGFloat {
        switch self {
        case .xxSmall, .xSmall: return 6
        case .small:  return 8
        case .medium: return 10
        case .large:  return 10
        case .xLarge: return 12
        case .xxLarge: return 14
        }
    }

    var statusBorderWidth: CGFloat { 2 }
}

// MARK: - AvatarStatus

enum DSAvatarStatus {
    case online
    case offline
    case busy

    var color: Color {
        switch self {
        case .online:  return DS.Color.success
        case .offline: return DS.Color.textDisabled
        case .busy:    return DS.Color.error
        }
    }
}

// MARK: - AvatarShape

enum DSAvatarShape {
    case circle
    case roundedSquare  // radius = 30% от размера
}

// MARK: - DSAvatar

struct DSAvatar: View {

    let size: DSAvatarSize
    let shape: DSAvatarShape
    let imageName: String?       // Asset name
    let initials: String?        // "AB"
    let status: DSAvatarStatus?
    let badgeCount: Int?         // nil = скрыт
    let backgroundColor: Color

    init(
        size: DSAvatarSize = .medium,
        shape: DSAvatarShape = .circle,
        imageName: String? = nil,
        initials: String? = nil,
        status: DSAvatarStatus? = nil,
        badgeCount: Int? = nil,
        backgroundColor: Color = DS.Color.brandPrimaryLighter
    ) {
        self.size = size
        self.shape = shape
        self.imageName = imageName
        self.initials = initials
        self.status = status
        self.badgeCount = badgeCount
        self.backgroundColor = backgroundColor
    }

    private var diameter: CGFloat { size.dimension }

    private var cornerRadius: CGFloat {
        switch shape {
        case .circle:        return diameter / 2
        case .roundedSquare: return diameter * 0.25
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            avatarContent
                .frame(width: diameter, height: diameter)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            if let status {
                statusBadge(status)
            }

            if let count = badgeCount, count > 0 {
                notificationBadge(count)
            }
        }
    }

    // MARK: - Avatar Content

    @ViewBuilder
    private var avatarContent: some View {
        if let imageName, UIImage(named: imageName) != nil {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .background(backgroundColor)
        } else if let initials {
            backgroundColor
            Text(initials.prefix(2).uppercased())
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundStyle(DS.Color.brandPrimary)
        } else {
            DS.Color.bgSurface
            Image(systemName: "person.fill")
                .font(.system(size: size.iconSize))
                .foregroundStyle(DS.Color.textSoft)
        }
    }

    // MARK: - Status Dot

    private func statusBadge(_ status: DSAvatarStatus) -> some View {
        Circle()
            .fill(status.color)
            .frame(width: size.statusDotSize, height: size.statusDotSize)
            .overlay(
                Circle()
                    .stroke(DS.Color.bgWhite, lineWidth: size.statusBorderWidth)
            )
            .offset(x: 2, y: 2)
    }

    // MARK: - Notification Badge

    private func notificationBadge(_ count: Int) -> some View {
        let label = count > 99 ? "99+" : "\(count)"
        return Text(label)
            .font(.system(size: 10, weight: .bold))
            .foregroundStyle(DS.Color.textWhite)
            .padding(.horizontal, 4)
            .frame(minWidth: 18, minHeight: 18)
            .background(DS.Color.error)
            .clipShape(Capsule())
            .offset(x: 4, y: -4)
    }
}

// MARK: - DSAvatarGroup

struct DSAvatarGroup: View {
    let avatars: [(imageName: String?, initials: String?)]
    let size: DSAvatarSize
    let maxVisible: Int
    let overlap: CGFloat

    init(
        avatars: [(imageName: String?, initials: String?)],
        size: DSAvatarSize = .small,
        maxVisible: Int = 4,
        overlap: CGFloat = 8
    ) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
        self.overlap = overlap
    }

    var body: some View {
        let visible = Array(avatars.prefix(maxVisible))
        let extra = avatars.count - maxVisible

        HStack(spacing: -overlap) {
            ForEach(visible.indices, id: \.self) { i in
                DSAvatar(
                    size: size,
                    imageName: visible[i].imageName,
                    initials: visible[i].initials
                )
                .overlay(
                    Circle()
                        .stroke(DS.Color.bgWhite, lineWidth: 2)
                )
                .zIndex(Double(visible.count - i))
            }

            if extra > 0 {
                ZStack {
                    DS.Color.bgSurface
                    Text("+\(extra)")
                        .font(.system(size: size.fontSize, weight: .semibold))
                        .foregroundStyle(DS.Color.textSub)
                }
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
                .overlay(Circle().stroke(DS.Color.bgWhite, lineWidth: 2))
            }
        }
    }
}

// MARK: - Preview

#Preview("DSAvatar") {
    ScrollView {
        VStack(alignment: .leading, spacing: DS.Spacing.lg) {

            Text("Sizes").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            HStack(spacing: DS.Spacing.md) {
                DSAvatar(size: .xxSmall, initials: "AB")
                DSAvatar(size: .xSmall, initials: "AB")
                DSAvatar(size: .small, initials: "AB")
                DSAvatar(size: .medium, initials: "AB")
                DSAvatar(size: .large, initials: "AB")
                DSAvatar(size: .xLarge, initials: "AB")
                DSAvatar(size: .xxLarge, initials: "AB")
            }

            Text("Fallback icon").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            HStack(spacing: DS.Spacing.md) {
                DSAvatar(size: .small)
                DSAvatar(size: .medium)
                DSAvatar(size: .large)
            }

            Text("Status badges").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            HStack(spacing: DS.Spacing.md) {
                DSAvatar(size: .large, initials: "ON", status: .online)
                DSAvatar(size: .large, initials: "OF", status: .offline)
                DSAvatar(size: .large, initials: "BY", status: .busy)
            }

            Text("Notification badge").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            HStack(spacing: DS.Spacing.md) {
                DSAvatar(size: .large, initials: "AB", badgeCount: 3)
                DSAvatar(size: .large, initials: "AB", badgeCount: 99)
                DSAvatar(size: .large, initials: "AB", badgeCount: 120)
            }

            Text("Rounded square").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            HStack(spacing: DS.Spacing.md) {
                DSAvatar(size: .medium, shape: .roundedSquare, initials: "VM")
                DSAvatar(size: .large, shape: .roundedSquare, initials: "VM")
                DSAvatar(size: .xLarge, shape: .roundedSquare, initials: "VM")
            }

            Text("Avatar Group").dsFont(DS.Typography.labelSm).foregroundStyle(DS.Color.textSub)
            DSAvatarGroup(avatars: [
                (nil, "AB"), (nil, "VM"), (nil, "JD"), (nil, "KL"), (nil, "MN"), (nil, "OP")
            ], size: .small, maxVisible: 4)
        }
        .padding(DS.Spacing.md)
    }
    .background(DS.Color.bgWeak)
}
