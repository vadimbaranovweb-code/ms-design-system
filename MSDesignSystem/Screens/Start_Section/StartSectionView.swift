// StartSectionView.swift
// Screens/Start_Section/StartSectionView.swift
//
// Собрано из Figma — MS Design System 2
// node-id: 10440:16188

import SwiftUI

// MARK: - StartSectionView

struct StartSectionView: View {

    var onStart: () -> Void = {}

    // Figma asset (expires in 7 days) — заменить на Assets.xcassets
    private let heroImageURL = URL(
        string: "https://www.figma.com/api/mcp/asset/51aecd02-f4f7-4eb4-b5a7-27d25a1eb7c5"
    )

    var body: some View {
        ZStack {
            // Фон — Blue/Darker #162664
            DS.Primitive.Blue.darker
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Карточка + текст
                VStack(spacing: DS.Spacing.s24) {
                    heroCard
                    textBlock
                }
                .padding(.horizontal, DS.Spacing.s24)

                Spacer()

                // CTA кнопка
                DSButton(
                    "Начать сканирование",
                    isFullWidth: true,
                    action: onStart
                )
                .padding(.horizontal, DS.Spacing.s48)
                .padding(.bottom, DS.Spacing.s48)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        ZStack(alignment: .topTrailing) {

            // Иллюстрация с фото
            AsyncImage(url: heroImageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    DS.Color.brandPrimaryLighter
                @unknown default:
                    DS.Color.brandPrimaryLighter
                }
            }
            .frame(width: 254, height: 307)
            .clipShape(RoundedRectangle(cornerRadius: DS.Radius.xxl))  // 24pt

            // Badge — "Популярное ⚡"
            DSBadge("Популярное", rightIcon: "bolt.fill", color: .orange, style: .filled)
                .padding(.top, DS.Spacing.s12)
                .padding(.trailing, DS.Spacing.s12)
        }
    }

    // MARK: - Text Block

    private var textBlock: some View {
        VStack(spacing: DS.Spacing.s4) {
            Text("Find Similar Photos")
                .dsFont(DS.Typography.h4)              // 32pt medium
                .foregroundStyle(DS.Color.textWhite)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Text("Quickly detect duplicates and clean up your gallery")
                .dsFont(DS.Typography.paragraphMd)     // 16pt regular
                .foregroundStyle(DS.Color.textDisabled)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#Preview("StartSection") {
    StartSectionView(onStart: {
        print("Начать сканирование tapped")
    })
}
