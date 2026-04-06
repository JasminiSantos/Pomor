import SwiftUI

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
                    .foregroundColor(isDestructive ? color : .primary)
                
                Spacer()
            }
            .padding()
            .background(background)
            .cornerRadius(16)
            .overlay(border)
        }
    }
    
    private var background: Color {
        isDestructive ? Color.clear : Color.white
    }
    
    private var border: some View {
        RoundedRectangle(cornerRadius: 16)
            .stroke(
                isDestructive ? color.opacity(0.25) : Color.clear,
                lineWidth: 1
            )
    }
}
