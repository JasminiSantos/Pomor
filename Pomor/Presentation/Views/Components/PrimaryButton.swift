import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(.main)
                .cornerRadius(30)
                .shadow(color: .main.opacity(0.3), radius: 10, y: 5)
        }
    }
}
