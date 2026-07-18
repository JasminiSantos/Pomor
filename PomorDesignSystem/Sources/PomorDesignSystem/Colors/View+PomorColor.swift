import SwiftUI

/// Papéis semânticos de cor — espelha o padrão de `.pomorFont(_:)`.
public enum PomorColorRole {
    case brand
    case onBrand
    case brandSoft
    case brandShadow
    case background
    case surface
    case overlay
    case muted
    case textPrimary
    case textSecondary
    case textTertiary
    case borderSubtle
    case destructive

    public var color: Color {
        switch self {
        case .brand:          PomorColor.Brand.primary
        case .onBrand:        PomorColor.Brand.onPrimary
        case .brandSoft:      PomorColor.Brand.soft
        case .brandShadow:    PomorColor.Brand.shadow
        case .background:     PomorColor.Background.app
        case .surface:        PomorColor.Background.surface
        case .overlay:        PomorColor.Background.overlay
        case .muted:          PomorColor.Background.muted
        case .textPrimary:    PomorColor.Text.primary
        case .textSecondary:  PomorColor.Text.secondary
        case .textTertiary:   PomorColor.Text.tertiary
        case .borderSubtle:   PomorColor.Border.subtle
        case .destructive:    PomorColor.Feedback.destructive
        }
    }
}

public extension ShapeStyle where Self == Color {
    static func pomor(_ role: PomorColorRole) -> Color {
        role.color
    }
}

public extension View {
    func pomorForeground(_ role: PomorColorRole) -> some View {
        foregroundStyle(role.color)
    }

    func pomorBackground(_ role: PomorColorRole) -> some View {
        background(role.color)
    }
}
