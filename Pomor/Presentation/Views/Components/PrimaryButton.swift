import SwiftUI
import PomorDesignSystem

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .pomorFont(.button)
                .foregroundStyle(.pomor(.onBrand))
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.pomor(.brand))
                .cornerRadius(30)
                .shadow(color: .pomor(.brandShadow), radius: 10, y: 5)
        }
    }
}
