import SwiftUI
import PomorDesignSystem

struct CircleButton: View {
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundStyle(.pomor(.textTertiary))
                .frame(width: 50, height: 50)
                .background(.pomor(.surface))
                .clipShape(Circle())
        }
    }
}
