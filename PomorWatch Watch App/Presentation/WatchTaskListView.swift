import SwiftUI
import PomorCore

struct WatchTaskListView: View {
    @EnvironmentObject var viewModel: WatchTaskListViewModel
    @State private var showAdd = false

    var body: some View {
        List {
            if viewModel.tasks.isEmpty {
                Text("No tasks.\nTap + to add one.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .listRowBackground(Color.clear)
            }

            ForEach(viewModel.tasks) { task in
                NavigationLink {
                    WatchTimerView(task: task)
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: task.icon)
                            .foregroundColor(.red)
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(.body)
                                .lineLimit(1)
                            Text("\(task.duration) min")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .onDelete { viewModel.delete(at: $0) }
        }
        .navigationTitle("Pomor")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button { showAdd = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAdd) {
            WatchAddTaskView()
        }
    }
}
