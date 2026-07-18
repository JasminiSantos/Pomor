import SwiftUI
import PomorDesignSystem

struct MenuActionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let isDestructive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: systemImage)
                            .foregroundColor(color)
                    )
                
                Text(title)
                    .pomorFont(.label)
                    .foregroundStyle(isDestructive ? color : Color.pomor(.textPrimary))

                Spacer()
            }
            .padding()
            .background(background)
            .cornerRadius(16)
            .overlay(border)
        }
    }

    private var background: Color {
        isDestructive ? Color.clear : .pomor(.surface)
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(
                isDestructive ? color.opacity(0.25) : Color.clear,
                lineWidth: 1
            )
    }
}
