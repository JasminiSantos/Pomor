import SwiftUI
import PomorDesignSystem

struct DeleteDialogView: View {
    let title: String
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        ZStack {
            Color.pomor(.overlay)
                .ignoresSafeArea()
                .onTapGesture {
                    onCancel()
                }

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(.pomor(.brandSoft))
                        .frame(width: 60, height: 60)

                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.pomor(.brand))
                        .font(.title2)
                }

                Text("Delete Task?")
                    .pomorFont(.title)
                    .pomorForeground(.textPrimary)

                Text("Are you sure you want to delete \"\(title)\"? This action cannot be undone.")
                    .pomorFont(.secondary)
                    .pomorForeground(.textTertiary)
                    .multilineTextAlignment(.center)

                Button(action: onConfirm) {
                    Text("Delete")
                        .pomorFont(.button)
                        .foregroundStyle(.pomor(.onBrand))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pomor(.destructive))
                        .cornerRadius(20)
                }

                Button(action: onCancel) {
                    Text("Cancel")
                        .pomorFont(.button)
                        .pomorForeground(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.pomor(.muted))
                        .cornerRadius(20)
                }
            }
            .padding()
            .background(.pomor(.surface))
            .cornerRadius(24)
            .padding(.horizontal, 32)
            .shadow(radius: 20)
        }
        .transition(.opacity)
    }
}
