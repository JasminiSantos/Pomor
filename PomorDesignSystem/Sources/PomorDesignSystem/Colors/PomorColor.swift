import SwiftUI

/// Tokens de cor da identidade Pomor.
/// Primitivos vivem no Asset Catalog do package; aqui mapeamos papéis semânticos.
public enum PomorColor {

    // MARK: - Brand

    public enum Brand {
        /// Coral principal (botões, marca, destaques)
        public static let primary = Color("MainColor", bundle: .module)
        /// Texto/ícone sobre brand
        public static let onPrimary = Color.white
        /// Fundo suave com a brand (ícones, chips)
        public static let soft = primary.opacity(0.10)
        /// Sombra tipicamente usada em FABs / CTAs
        public static let shadow = primary.opacity(0.35)
    }

    // MARK: - Background

    public enum Background {
        /// Fundo da app (peach suave)
        public static let app = Color("CustomBackground", bundle: .module)
        /// Cards, inputs, sheets
        public static let surface = Color("Surface", bundle: .module)
        /// Dimmer de modais
        public static let overlay = Color.black.opacity(0.40)
        /// Fundo secundário sutil (botões cancel, close)
        public static let muted = Color.black.opacity(0.06)
    }

    // MARK: - Text

    public enum Text {
        /// Títulos e conteúdo principal
        public static let primary = Color("TextPrimary", bundle: .module)
        /// Subtítulos / saudações
        public static let secondary = Color("TextSecondary", bundle: .module)
        /// Placeholders, captions, metadados
        public static let tertiary = Color("TextTertiary", bundle: .module)
        /// Texto sobre brand / botões preenchidos
        public static let onBrand = Brand.onPrimary
    }

    // MARK: - Border / Stroke

    public enum Border {
        public static let subtle = Color.black.opacity(0.06)
        public static let muted = Color.black.opacity(0.12)
    }

    // MARK: - Feedback

    public enum Feedback {
        public static let destructive = Brand.primary
        public static let destructiveSoft = Brand.soft
    }

    // MARK: - Timer states

    public enum Timer {
        public static let focusSoft = Brand.primary.opacity(0.10)
        public static let shortBreakSoft = Color.green.opacity(0.10)
        public static let longBreakSoft = Color.blue.opacity(0.10)
    }

    // MARK: - Illustration (TomatoMark)

    public enum Illustration {
        public static let tomato = Color(hex: 0xF4615C)
        public static let leaf = Color(hex: 0x5A8A3C)
        public static let leafDark = Color(hex: 0x4D7A32)
        public static let shine = Color.white.opacity(0.28)
        public static let rib = Color.black.opacity(0.06)
        public static let ribStroke = Color.black.opacity(0.05)
    }
}

public extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
