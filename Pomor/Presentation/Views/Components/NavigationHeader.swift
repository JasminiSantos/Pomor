import PomorDesignSystem
import SwiftUI

enum NavigationHeaderTitlePosition {
    case leading
    case center
}

struct NavigationHeader: View {
    let title: String
    var titlePosition: NavigationHeaderTitlePosition = .leading
    var onBack: (() -> Void)?

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        switch titlePosition {
        case .leading:
            leadingLayout
        case .center:
            centerLayout
        }
    }

    private var leadingLayout: some View {
        HStack(spacing: 12) {
            backButton
            titleText
            Spacer(minLength: 0)
        }
    }

    private var centerLayout: some View {
        ZStack {
            titleText

            HStack {
                backButton
                Spacer(minLength: 0)
            }
        }
    }

    private var titleText: some View {
        Text(title)
            .pomorFont(.screenTitle)
            .pomorForeground(.textPrimary)
            .lineLimit(1)
    }

    private var backButton: some View {
        Button(action: handleBack) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.pomor(.brand))
                .frame(width: 44, height: 44)
                .background(.pomor(.surface))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private func handleBack() {
        if let onBack {
            onBack()
        } else {
            dismiss()
        }
    }
}
