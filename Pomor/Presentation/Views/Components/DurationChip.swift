import SwiftUI
import PomorDesignSystem

struct DurationChip: View {
    let value: Int
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("\(value)m")
                .font(PomorFont.nunito(size: 16, weight: .medium))
                .foregroundStyle(isSelected ? .pomor(.onBrand) : .pomor(.textPrimary))
                .frame(width: 70, height: 50)
                .background(isSelected ? .pomor(.brand) : .pomor(.surface))
                .cornerRadius(16)
        }
    }
}
