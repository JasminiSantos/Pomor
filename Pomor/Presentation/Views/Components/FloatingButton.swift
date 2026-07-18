import SwiftUI
import PomorDesignSystem

struct FloatingButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold, design: .rounded))
                .foregroundStyle(.pomor(.onBrand))
                .frame(width: 64, height: 64)
                .background(.pomor(.brand))
                .clipShape(Circle())
                .shadow(color: .pomor(.brandShadow), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
