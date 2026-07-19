import SwiftUI
import PomorDesignSystem

struct TaskCard: View {
    let title: String
    let duration: Int
    let icon: String
    let onMenuTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.pomor(.brandSoft))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .foregroundStyle(.pomor(.brand))
            }

            VStack(alignment: .leading) {
                Text(title)
                    .pomorFont(.button)
                    .pomorForeground(.textPrimary)

                HStack {
                    Image(systemName: "clock")
                    Text("\(duration) min")
                }
                .pomorFont(.secondary)
                .pomorForeground(.textTertiary)
            }

            Spacer()

            Button(action: onMenuTap) {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .pomorForeground(.textTertiary)
                    .padding()
            }
        }
        .padding()
        .background(.pomor(.surface))
        .cornerRadius(16)
        .shadow(color: .pomor(.borderSubtle), radius: 5)
    }
}
