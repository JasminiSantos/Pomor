import SwiftUI

struct TimerCircle: View {
    let time: String
    let progress: Double
    let message: String
    
    var body: some View {
        ZStack {
            
            Circle()
                .fill(Color.gray.opacity(0.08))
                .frame(width: 260, height: 260)
            
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                .frame(width: 260, height: 260)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    .main,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 260, height: 260)
                .animation(.linear, value: progress)
            
            VStack(spacing: 8) {
                
                Text(time)
                    .font(.system(size: 48, weight: .bold))
                
                Text(message)
                    .foregroundColor(.gray)
                    .font(.subheadline)
            }
        }
    }
}

