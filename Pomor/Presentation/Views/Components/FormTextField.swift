import PomorDesignSystem
import SwiftUI

struct FormTextField: View {
    let label: String
    var placeholder: String = ""
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var onTextChange: ((String) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .pomorFont(.label)
                .pomorForeground(.textTertiary)

            TextField(placeholder, text: $text)
                .pomorFont(keyboardType == .numberPad ? .body : .placeholder)
                .pomorForeground(.textPrimary)
                .keyboardType(keyboardType)
                .onChange(of: text) { _, newValue in
                    onTextChange?(newValue)
                }
                .padding()
                .frame(height: 55)
                .background(.pomor(.surface))
                .cornerRadius(14)
        }
    }
}
