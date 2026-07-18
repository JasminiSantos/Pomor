import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

/// Tipografia da identidade Pomor.
/// - Nunito: headings, títulos, labels e botões
/// - Nunito Sans: corpo, subtítulos, textos secundários e placeholders
public enum PomorFont {

    public enum Family {
        case nunito
        case nunitoSans
    }

    public enum Weight: CGFloat {
        case regular = 400
        case medium = 500
        case semibold = 600
        case bold = 700
        case extraBold = 800
        case black = 900
    }

    /// PostScript / family names registrados via `FontRegistrar`.
    public static func postScriptName(family: Family, weight: Weight) -> String {
        switch family {
        case .nunito:
            switch weight {
            case .regular:   return "Nunito-Regular"
            case .medium:    return "Nunito-Medium"
            case .semibold:  return "Nunito-SemiBold"
            case .bold:      return "Nunito-Bold"
            case .extraBold: return "Nunito-ExtraBold"
            case .black:     return "Nunito-Black"
            }
        case .nunitoSans:
            switch weight {
            case .regular:   return "NunitoSans-Regular"
            case .medium:    return "NunitoSans-Medium"
            case .semibold:  return "NunitoSans-SemiBold"
            case .bold:      return "NunitoSans-Bold"
            case .extraBold, .black:
                return "NunitoSans-Bold"
            }
        }
    }

    public static func custom(_ family: Family, size: CGFloat, weight: Weight) -> Font {
        let name = postScriptName(family: family, weight: weight)

        #if canImport(UIKit)
        if UIFont(name: name, size: size) != nil {
            return .custom(name, size: size)
        }

        #if DEBUG
        print("⚠️ PomorFont unavailable: \(name) — falling back to system")
        #endif

        return .system(size: size, weight: systemWeight(for: weight), design: .rounded)
        #else
        return .custom(name, size: size)
        #endif
    }

    public static func nunito(size: CGFloat, weight: Weight = .regular) -> Font {
        custom(.nunito, size: size, weight: weight)
    }

    public static func nunitoSans(size: CGFloat, weight: Weight = .regular) -> Font {
        custom(.nunitoSans, size: size, weight: weight)
    }

    private static func systemWeight(for weight: Weight) -> SwiftUI.Font.Weight {
        switch weight {
        case .regular:   return .regular
        case .medium:    return .medium
        case .semibold:  return .semibold
        case .bold:      return .bold
        case .extraBold: return .heavy
        case .black:     return .black
        }
    }
}
