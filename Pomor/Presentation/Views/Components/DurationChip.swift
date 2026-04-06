import SwiftUI

struct DurationChip: View {
    let value: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(value)m")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 70, height: 50)
                .background(
                    isSelected
                    ? .main
                    : Color.white
                )
                .cornerRadius(16)
        }
    }
}
