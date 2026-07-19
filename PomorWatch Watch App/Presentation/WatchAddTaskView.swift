import SwiftUI

struct WatchAddTaskView: View {
    let onSubmit: (String, Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var duration = 25

    private let durations = [15, 20, 25, 30, 45, 60]

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        Form {
            TextField("Task name", text: $title)

            Picker("Duration", selection: $duration) {
                ForEach(durations, id: \.self) { minutes in
                    Text("\(minutes) min").tag(minutes)
                }
            }
        }
        .navigationTitle("New Task")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    onSubmit(title.trimmingCharacters(in: .whitespaces), duration)
                    dismiss()
                }
                .disabled(!isValid)
            }
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
        }
    }
}
