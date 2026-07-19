import SwiftUI
import PomorDesignSystem

enum TaskIcon: String, CaseIterable {
    case brain
    case book
    case laptop = "laptopcomputer"
    case pencil
    case gamecontroller
    case cupAndSaucer = "cup.and.saucer"
    case musicNote = "music.note"
    case target

    var systemName: String { rawValue }
}

struct IconSelector: View {
    let icons: [TaskIcon]
    @Binding var selection: TaskIcon

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(TaskFormStrings.Label.icon)
                .pomorFont(.label)
                .pomorForeground(.textTertiary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(icons, id: \.self) { icon in
                        iconButton(for: icon)
                    }
                }
            }
        }
    }

    private func iconButton(for icon: TaskIcon) -> some View {
        let isSelected = selection == icon

        return Button {
            selection = icon
        } label: {
            ZStack {
                Circle()
                    .fill(isSelected ? Color.pomor(.brand) : Color.pomor(.surface))
                    .frame(width: 50, height: 50)

                Image(systemName: icon.systemName)
                    .foregroundStyle(isSelected ? Color.pomor(.onBrand) : Color.pomor(.textTertiary))
            }
            .shadow(
                color: isSelected ? Color.pomor(.brandShadow) : .clear,
                radius: 6
            )
        }
    }
}
