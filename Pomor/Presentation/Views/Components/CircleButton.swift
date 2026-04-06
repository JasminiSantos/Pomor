import SwiftUI

struct CircleButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 50, height: 50)
                .background(Color.white)
                .clipShape(Circle())
        }
    }
}
