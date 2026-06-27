import SwiftUI

struct WatchAddTaskView: View {
    @EnvironmentObject var viewModel: WatchTaskListViewModel
    @Environment(\.dismiss) var dismiss

    @State private var title = ""
    @State private var duration = 25

    private let durations = [15, 20, 25, 30, 45, 60]

    private var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("Task name", text: $title)

                Picker("Duration", selection: $duration) {
                    ForEach(durations, id: \.self) { min in
                        Text("\(min) min").tag(min)
                    }
                }
            }
            .navigationTitle("New Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.add(
                            title: title.trimmingCharacters(in: .whitespaces),
                            duration: duration
                        )
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
}
