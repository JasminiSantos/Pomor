import SwiftUI

struct TaskListView: View {
    
    @ObservedObject var viewModel: TaskListViewModel
    @ObservedObject var coordinator: AppCoordinator
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            
            VStack {
                
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        if(viewModel.tasks.isEmpty){
                            Text("No tasks yet. Add one to get started.")
                        } else {
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
                                    coordinator.goToTimer(task: task)
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                FloatingButton {
                    coordinator.goToAddTask()
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            }
            .background(.customBackground)
        }
        .sheet(isPresented: $viewModel.showMenu) {
            TaskMenuSheet(
                onEdit: {
                    viewModel.showMenu = false
                    if let task = viewModel.selectedTask {
                        coordinator.goToEditTask(task: task)
                    }
                },
                onDelete: {
                    viewModel.showMenu = false
                    viewModel.showDeleteDialog = true
                }
            )
            .presentationDetents([.height(240)])
            .presentationDragIndicator(.hidden)
            .presentationBackground(Color.white)
            
        }
        .onAppear {
            viewModel.loadTasks()
        }
        .onChange(of: coordinator.path) { _ in
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
}
