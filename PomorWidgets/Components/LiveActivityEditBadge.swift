import PomorDesignSystem
import SwiftUI

struct LiveActivityEditBadge: View {
    enum Style {
        case square
        case progressRing(progress: Double)
    }

    var style: Style = .square

    var body: some View {
        switch style {
        case .square:
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(PomorColor.Brand.primary.opacity(0.22))
                .frame(width: 48, height: 48)
                .overlay {
                    Image(systemName: "pencil")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(PomorColor.Brand.primary)
                }
        case .progressRing(let progress):
            LiveActivityProgressRing(progress: progress, size: 40, lineWidth: 3) {
                Image(systemName: "pencil")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
}
