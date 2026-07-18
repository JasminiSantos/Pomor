import PomorCore
import PomorDesignSystem
import SwiftUI

struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel

    let onTimer: (PomTask) -> Void
    let onAdd: () -> Void
    let onEdit: (PomTask) -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                header
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 20)

                if viewModel.tasks.isEmpty {
                    emptyState
                } else {
                    taskList
                }
            }

            FloatingButton { onAdd() }
                .padding(.trailing, 24)
                .padding(.bottom, 28)
        }
        .background(Color.pomor(.background).ignoresSafeArea())
        .sheet(isPresented: $viewModel.showMenu) {
            TaskMenuSheet(
                onEdit: {
                    viewModel.showMenu = false
                    if let task = viewModel.selectedTask {
                        onEdit(task)
                    }
                },
                onDelete: {
                    viewModel.showMenu = false
                    viewModel.showDeleteDialog = true
                }
            )
            .presentationDetents([.height(240)])
            .presentationDragIndicator(.hidden)
            .presentationBackground(Color.pomor(.surface))
        }
        .onAppear {
            viewModel.loadTasks()
        }
        .overlay {
            if viewModel.showDeleteDialog {
                DeleteDialogView(
                    title: viewModel.selectedTask?.title ?? "",
                    onConfirm: {
                        viewModel.deleteTask()
                        viewModel.showDeleteDialog = false
                    },
                    onCancel: {
                        viewModel.showDeleteDialog = false
                    }
                )
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                TomatoMark(size: 26)

                Text(TaskListStrings.Brand.name)
                    .pomorFont(.brand)
                    .pomorForeground(.brand)
            }

            Text(TaskListStrings.Greeting.message())
                .pomorFont(.subtitle)
                .pomorForeground(.textSecondary)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()

            TomatoMark(size: 88, isFloating: true)

            Text(TaskListStrings.EmptyState.title)
                .pomorFont(.title)
                .pomorForeground(.textPrimary)

            Text(TaskListStrings.EmptyState.message)
                .pomorFont(.secondary)
                .pomorForeground(.textTertiary)
                .multilineTextAlignment(.center)

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 32)
    }

    private var taskList: some View {
        ScrollView {
            LazyVStack(spacing: 14) {
                ForEach(viewModel.tasks) { task in
                    TaskCard(
                        title: task.title,
                        duration: task.duration,
                        icon: task.icon
                    ) {
                        viewModel.selectedTask = task
                        viewModel.showMenu = true
                    }
                    .onTapGesture {
                        onTimer(task)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 100)
        }
    }
}
