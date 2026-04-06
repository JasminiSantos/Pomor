import SwiftUI

struct DeleteDialogView: View {
    let title: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }
            
            VStack(spacing: 20) {
                
                ZStack {
                    Circle()
                        .fill(.main.opacity(0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.main)
                        .font(.title2)
                }
                
                Text("Delete Task?")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Are you sure you want to delete \"\(title)\"? This action cannot be undone.")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Button(action: onConfirm) {
                    Text("Delete")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.main)
                        .cornerRadius(20)
                }
                
                Button(action: onCancel) {
                    Text("Cancel")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal, 32)
            .shadow(radius: 20)
        }
        .transition(.opacity)
    }
}
