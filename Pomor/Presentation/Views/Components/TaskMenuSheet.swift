import SwiftUI

struct TaskMenuSheet: View {
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .frame(width: 36, height: 36)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 4)
            
            MenuActionButton(
                title: "Edit Task",
                systemImage: "pencil",
                color: .blue,
                isDestructive: false
            ) {
                dismiss()
                onEdit()
            }
            
            MenuActionButton(
                title: "Delete Task",
                systemImage: "trash",
                color: .main,
                isDestructive: true
            ) {
                dismiss()
                onDelete()
            }
        }
        .padding(.horizontal, 20)
    }
}
