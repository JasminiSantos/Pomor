import SwiftUI

struct FloatingButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title)
                .frame(width: 60, height: 60)
                .background(Color.red)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}
