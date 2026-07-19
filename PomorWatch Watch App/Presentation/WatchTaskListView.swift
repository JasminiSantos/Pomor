import SwiftUI
import PomorCore
import PomorDesignSystem

struct WatchTaskListView: View {
    @ObservedObject var viewModel: WatchTaskListViewModel

    var body: some View {
        Group {
            if viewModel.tasks.isEmpty {
                emptyState
            } else {
                taskList
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                brandHeader
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: WatchRoute.addTask) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 10) {
            Spacer(minLength: 0)

            TomatoMark(size: 52, isFloating: true)

            Text(emptyMessage)
                .font(PomorFont.nunitoSans(size: 12, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 4)

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var brandHeader: some View {
        HStack(spacing: 5) {
            TomatoMark(size: 16)
            Text(WatchTaskListStrings.Brand.name)
                .font(PomorFont.nunito(size: 13, weight: .extraBold))
                .tracking(1.2)
                .foregroundStyle(.primary)
        }
    }

    private var taskList: some View {
        List {
            ForEach(viewModel.tasks) { task in
                NavigationLink(value: WatchRoute.timer(task)) {
                    HStack(spacing: 8) {
                        Image(systemName: task.icon)
                            .foregroundStyle(PomorColor.Brand.primary)
                            .frame(width: 20)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(task.title)
                                .font(.body)
                                .lineLimit(1)
                            Text("\(task.duration) min")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewModel.delete(task)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }

    private var emptyMessage: String {
        viewModel.hasSyncedFromPhone
            ? WatchTaskListStrings.EmptyState.synced
            : WatchTaskListStrings.EmptyState.waiting
    }
}
