import SwiftUI

/// Tokens semânticos de tipografia do design system Pomor.
public enum PomorTextStyle {
    /// Nome da marca (ex.: "Pomor" na home)
    case brand
    /// Título de tela (ex.: "New Task")
    case screenTitle
    /// Título de seção / empty state
    case title
    /// Label de formulário
    case label
    /// Texto de botão primário
    case button
    /// Corpo de texto
    case body
    /// Subtítulo / saudação
    case subtitle
    /// Texto secundário / metadados
    case secondary
    /// Placeholder de TextField
    case placeholder
    /// Timer grande
    case timer

    public var font: Font {
        switch self {
        case .brand:
            PomorFont.nunito(size: 32, weight: .extraBold)
        case .screenTitle:
            PomorFont.nunito(size: 22, weight: .bold)
        case .title:
            PomorFont.nunito(size: 22, weight: .bold)
        case .label:
            PomorFont.nunito(size: 14, weight: .semibold)
        case .button:
            PomorFont.nunito(size: 17, weight: .bold)
        case .body:
            PomorFont.nunitoSans(size: 16, weight: .regular)
        case .subtitle:
            PomorFont.nunitoSans(size: 16, weight: .medium)
        case .secondary:
            PomorFont.nunitoSans(size: 14, weight: .regular)
        case .placeholder:
            PomorFont.nunitoSans(size: 16, weight: .regular)
        case .timer:
            PomorFont.nunito(size: 48, weight: .bold)
        }
    }
}

public extension Font {
    static func pomor(_ style: PomorTextStyle) -> Font {
        style.font
    }
}

public extension View {
    func pomorFont(_ style: PomorTextStyle) -> some View {
        font(.pomor(style))
    }
}
