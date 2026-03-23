// DesignTokens.swift
// DesignSystem/Tokens/DesignTokens.swift
//
// ⚠️  СГЕНЕРИРОВАНО из Figma — MS Design System 2 (AlignUI)
//     Источник: figma.com/design/pBejCIZ8Kua31tXOQnTvVc
//     Обновлено: цвета (node 6694:84700) + типографика (node 6800:896)

import SwiftUI

// MARK: - Design System Namespace

enum DS {

    // MARK: - Primitive Colors
    // Строительные блоки — не использовать в UI напрямую

    enum Primitive {

        enum Neutral {
            static let black     = SwiftUI.Color(hex: "#0A0D14")
            static let darkGray  = SwiftUI.Color(hex: "#161922")
            static let gray      = SwiftUI.Color(hex: "#20232D")
            static let lightGray = SwiftUI.Color(hex: "#31353F")
            static let sub       = SwiftUI.Color(hex: "#525866")
            static let soft      = SwiftUI.Color(hex: "#868C98")
            static let disabled  = SwiftUI.Color(hex: "#CDD0D5")
            static let neutral   = SwiftUI.Color(hex: "#E2E4E9")
            static let weak      = SwiftUI.Color(hex: "#F6F8FA")
            static let white     = SwiftUI.Color(hex: "#FFFFFF")
        }

        enum Blue {
            static let darker  = SwiftUI.Color(hex: "#162664")
            static let dark    = SwiftUI.Color(hex: "#253EA7")
            static let base    = SwiftUI.Color(hex: "#375DFB")
            static let light   = SwiftUI.Color(hex: "#C2D6FF")
            static let lighter = SwiftUI.Color(hex: "#EBF1FF")
        }

        enum Purple {
            static let darker  = SwiftUI.Color(hex: "#2B1664")
            static let dark    = SwiftUI.Color(hex: "#5A36BF")
            static let base    = SwiftUI.Color(hex: "#6E3FF3")
            static let light   = SwiftUI.Color(hex: "#CAC2FF")
            static let lighter = SwiftUI.Color(hex: "#EEEBFF")
        }

        enum Red {
            static let darker  = SwiftUI.Color(hex: "#710E21")
            static let dark    = SwiftUI.Color(hex: "#AF1D38")
            static let base    = SwiftUI.Color(hex: "#DF1C41")
            static let light   = SwiftUI.Color(hex: "#F8C9D2")
            static let lighter = SwiftUI.Color(hex: "#FDEDF0")
        }

        enum Green {
            static let darker  = SwiftUI.Color(hex: "#176448")
            static let dark    = SwiftUI.Color(hex: "#2D9F75")
            static let base    = SwiftUI.Color(hex: "#38C793")
            static let light   = SwiftUI.Color(hex: "#CBF5E5")
            static let lighter = SwiftUI.Color(hex: "#EFFAF6")
        }

        enum Orange {
            static let darker  = SwiftUI.Color(hex: "#6E330C")
            static let dark    = SwiftUI.Color(hex: "#C2540A")
            static let base    = SwiftUI.Color(hex: "#F17B2C")
            static let light   = SwiftUI.Color(hex: "#FFDAC2")
            static let lighter = SwiftUI.Color(hex: "#FEF3EB")
        }

        enum Yellow {
            static let darker  = SwiftUI.Color(hex: "#693D11")
            static let dark    = SwiftUI.Color(hex: "#B47818")
            static let base    = SwiftUI.Color(hex: "#F2AE40")
            static let light   = SwiftUI.Color(hex: "#FBDFB1")
            static let lighter = SwiftUI.Color(hex: "#FEF7EC")
        }

        enum Pink {
            static let darker  = SwiftUI.Color(hex: "#620F6C")
            static let dark    = SwiftUI.Color(hex: "#9C23A9")
            static let base    = SwiftUI.Color(hex: "#E255F2")
            static let light   = SwiftUI.Color(hex: "#F9C2FF")
            static let lighter = SwiftUI.Color(hex: "#FDEBFF")
        }

        enum Teal {
            static let darker  = SwiftUI.Color(hex: "#164564")
            static let dark    = SwiftUI.Color(hex: "#1F87AD")
            static let base    = SwiftUI.Color(hex: "#35B9E9")
            static let light   = SwiftUI.Color(hex: "#C2EFFF")
            static let lighter = SwiftUI.Color(hex: "#EBFAFF")
        }
    }

    // MARK: - Semantic Colors
    // Используй ТОЛЬКО эти в UI-коде

    enum Color {

        // Backgrounds
        static let bgWhite   = Primitive.Neutral.white
        static let bgWeak    = Primitive.Neutral.weak     // #F6F8FA — фон страниц
        static let bgSurface = Primitive.Neutral.neutral  // #E2E4E9 — карточки

        // Text
        static let textMain     = Primitive.Neutral.black    // #0A0D14
        static let textSub      = Primitive.Neutral.sub      // #525866
        static let textSoft     = Primitive.Neutral.soft     // #868C98
        static let textDisabled = Primitive.Neutral.disabled // #CDD0D5
        static let textWhite    = Primitive.Neutral.white    // #FFFFFF

        // Borders
        static let strokeSoft   = Primitive.Neutral.neutral  // #E2E4E9
        static let strokeStrong = Primitive.Neutral.soft     // #868C98

        // Brand Primary — Blue
        static let brandPrimary        = Primitive.Blue.base      // #375DFB
        static let brandPrimaryDark    = Primitive.Blue.dark      // #253EA7
        static let brandPrimaryDarker  = Primitive.Blue.darker    // #162664
        static let brandPrimaryLight   = Primitive.Blue.light     // #C2D6FF
        static let brandPrimaryLighter = Primitive.Blue.lighter   // #EBF1FF

        // Brand Secondary — Purple
        static let brandSecondary        = Primitive.Purple.base    // #6E3FF3
        static let brandSecondaryDark    = Primitive.Purple.dark    // #5A36BF
        static let brandSecondaryLight   = Primitive.Purple.light   // #CAC2FF
        static let brandSecondaryLighter = Primitive.Purple.lighter // #EEEBFF

        // Success — Green
        static let success        = Primitive.Green.base     // #38C793
        static let successDark    = Primitive.Green.dark     // #2D9F75
        static let successLight   = Primitive.Green.light    // #CBF5E5
        static let successLighter = Primitive.Green.lighter  // #EFFAF6

        // Warning — Orange
        static let warning        = Primitive.Orange.base    // #F17B2C
        static let warningDark    = Primitive.Orange.dark    // #C2540A
        static let warningLight   = Primitive.Orange.light   // #FFDAC2
        static let warningLighter = Primitive.Orange.lighter // #FEF3EB

        // Error — Red
        static let error        = Primitive.Red.base     // #DF1C41
        static let errorDark    = Primitive.Red.dark     // #AF1D38
        static let errorLight   = Primitive.Red.light    // #F8C9D2
        static let errorLighter = Primitive.Red.lighter  // #FDEDF0

        // Info — Teal
        static let info        = Primitive.Teal.base     // #35B9E9
        static let infoLight   = Primitive.Teal.light    // #C2EFFF
        static let infoLighter = Primitive.Teal.lighter  // #EBFAFF

        // Neutral UI (тёмные кнопки)
        static let neutralBase   = Primitive.Neutral.gray      // #20232D
        static let neutralStrong = Primitive.Neutral.lightGray // #31353F
        static let neutralDark   = Primitive.Neutral.darkGray  // #161922
    }

    // MARK: - Typography
    // Точно из Figma (node 6800:896), SF Pro Display

    enum Typography {

        // Titles
        static let h1 = DSFont(size: 56, weight: .medium, lineHeight: 64, tracking: -1.0)
        static let h2 = DSFont(size: 48, weight: .medium, lineHeight: 56, tracking: -1.0)
        static let h3 = DSFont(size: 40, weight: .medium, lineHeight: 48, tracking: -1.0)
        static let h4 = DSFont(size: 32, weight: .medium, lineHeight: 40, tracking:  0.0)
        static let h5 = DSFont(size: 24, weight: .medium, lineHeight: 32, tracking:  0.0)
        static let h6 = DSFont(size: 20, weight: .medium, lineHeight: 28, tracking:  0.0)

        // Labels (Medium weight — кнопки, теги, badges)
        static let labelXL = DSFont(size: 24, weight: .medium, lineHeight: 32, tracking: -1.5)
        static let labelLg = DSFont(size: 18, weight: .medium, lineHeight: 24, tracking: -1.5)
        static let labelMd = DSFont(size: 16, weight: .medium, lineHeight: 24, tracking: -1.1)
        static let labelSm = DSFont(size: 14, weight: .medium, lineHeight: 20, tracking: -0.6) // кнопки
        static let labelXS = DSFont(size: 12, weight: .medium, lineHeight: 16, tracking:  0.0)

        // Paragraphs (Regular weight — основной текст)
        static let paragraphXL = DSFont(size: 24, weight: .regular, lineHeight: 32, tracking: -1.5)
        static let paragraphLg = DSFont(size: 18, weight: .regular, lineHeight: 24, tracking: -1.5)
        static let paragraphMd = DSFont(size: 16, weight: .regular, lineHeight: 24, tracking: -1.1)
        static let paragraphSm = DSFont(size: 14, weight: .regular, lineHeight: 20, tracking: -0.6)
        static let paragraphXS = DSFont(size: 12, weight: .regular, lineHeight: 16, tracking:  0.0)

        // Subheadings (Uppercase, tracking+)
        static let subheadingMd  = DSFont(size: 16, weight: .medium, lineHeight: 24, tracking: 6.0)
        static let subheadingSm  = DSFont(size: 14, weight: .medium, lineHeight: 20, tracking: 6.0)
        static let subheadingXS  = DSFont(size: 12, weight: .medium, lineHeight: 16, tracking: 4.0)
        static let subheading2XS = DSFont(size: 11, weight: .medium, lineHeight: 12, tracking: 2.0)
    }

    // MARK: - Spacing
    // Шкала кратная 2/4/8 — стандарт iOS

    enum Spacing {
        static let s2:  CGFloat = 2
        static let s4:  CGFloat = 4
        static let s8:  CGFloat = 8
        static let s10: CGFloat = 10
        static let s12: CGFloat = 12
        static let s16: CGFloat = 16
        static let s20: CGFloat = 20
        static let s24: CGFloat = 24
        static let s32: CGFloat = 32
        static let s36: CGFloat = 36
        static let s40: CGFloat = 40
        static let s48: CGFloat = 48
        static let s56: CGFloat = 56

        // Semantic aliases — используй эти в компонентах
        static let xs:   CGFloat = 4
        static let sm:   CGFloat = 8
        static let md:   CGFloat = 16
        static let lg:   CGFloat = 24
        static let xl:   CGFloat = 32
        static let xxl:  CGFloat = 48
        static let xxxl: CGFloat = 56
    }

    // MARK: - Corner Radius

    enum Radius {
        static let xs:   CGFloat = 8
        static let sm:   CGFloat = 10  // Medium button (Figma)
        static let md:   CGFloat = 12  // Cards, tiles (Figma)
        static let lg:   CGFloat = 16
        static let xl:   CGFloat = 20
        static let xxl:  CGFloat = 24
        static let full: CGFloat = 9999
    }

    // MARK: - Shadows

    enum Shadow {
        struct Config {
            let color: SwiftUI.Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat
        }

        // Из Figma button-shadow/fancy
        static let buttonNeutral = Config(color: SwiftUI.Color(hex: "#1B1C1D").opacity(0.48), radius: 2, x: 0, y: 1)
        static let buttonBlue    = Config(color: SwiftUI.Color(hex: "#253EA7").opacity(0.48), radius: 2, x: 0, y: 1)
        static let buttonPurple  = Config(color: SwiftUI.Color(hex: "#5A36BF").opacity(0.48), radius: 2, x: 0, y: 1)
        static let buttonRed     = Config(color: SwiftUI.Color(hex: "#AF1D1D").opacity(0.48), radius: 2, x: 0, y: 1)

        // Из Figma regular-shadow
        static let xSmall = Config(color: SwiftUI.Color(hex: "#E4E5E7").opacity(0.24), radius: 2, x: 0, y: 1)
        static let sm     = Config(color: .black.opacity(0.08), radius: 4,  x: 0, y: 2)
        static let md     = Config(color: .black.opacity(0.10), radius: 8,  x: 0, y: 4)
        static let lg     = Config(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
    }

    // MARK: - Animation

    enum Animation {
        static let fast     = SwiftUI.Animation.easeOut(duration: 0.15)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.25)
        static let spring   = SwiftUI.Animation.spring(response: 0.35, dampingFraction: 0.7)
    }
}

// MARK: - DSFont
// Хелпер для применения типографики с lineHeight и tracking

struct DSFont {
    let size: CGFloat
    let weight: Font.Weight
    let lineHeight: CGFloat
    let tracking: CGFloat  // letterSpacing из Figma (в pt)

    var font: Font {
        Font.system(size: size, weight: weight, design: .default)
    }
}

// Удобный модификатор — применяет font + tracking вместе
extension View {
    func dsFont(_ style: DSFont) -> some View {
        self
            .font(style.font)
            .tracking(style.tracking)
    }
}

// MARK: - Color(hex:) Extension

extension SwiftUI.Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:  (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:  (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:  (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB,
                  red:     Double(r) / 255,
                  green:   Double(g) / 255,
                  blue:    Double(b) / 255,
                  opacity: Double(a) / 255)
    }
}

// MARK: - Shadow Modifier

extension View {
    func dsShadow(_ shadow: DS.Shadow.Config) -> some View {
        self.shadow(color: shadow.color, radius: shadow.radius, x: shadow.x, y: shadow.y)
    }
}
