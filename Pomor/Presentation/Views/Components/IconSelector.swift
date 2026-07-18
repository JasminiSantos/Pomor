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
    
    var systemName: String {
        rawValue
    }
}

struct IconSelector: View {
    
    let icons = TaskIcon.allCases
    
    @State private var selectedIcon: TaskIcon = .target
    
    var body: some View {
        HStack {
            ForEach(icons, id: \.self) { icon in
                Button {
                    selectedIcon = icon
                } label: {
                    Image(systemName: icon.systemName)
                        .padding()
                        .background(selectedIcon == icon ? .pomor(.brand) : .pomor(.muted))
                        .foregroundStyle(selectedIcon == icon ? .pomor(.onBrand) : .pomor(.textPrimary))
                        .clipShape(Circle())
                }
            }
        }
    }
}
