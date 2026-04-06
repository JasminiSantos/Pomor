import SwiftUI

struct TaskCard: View {
    let title: String
    let duration: Int
    let icon: String
    let onMenuTap: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.main.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .foregroundColor(.main)
            }
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                HStack {
                    Image(systemName: "clock")
                    Text("\(duration) min")
                }
                .font(.subheadline)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button(action: onMenuTap) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .padding()
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}
