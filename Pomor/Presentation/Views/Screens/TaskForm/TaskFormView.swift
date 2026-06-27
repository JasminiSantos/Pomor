import PomorCore
import SwiftUI

enum TaskFormMode: Hashable {
    case create
    case edit(PomTask)

    var navigationTitle: String {
        switch self {
        case .create: return "New Task"
        case .edit:   return "Edit Task"
        }
    }

    var buttonTitle: String {
        switch self {
        case .create: return "Create Task"
        case .edit:   return "Save Changes"
        }
    }
}

struct TaskFormView: View {
    
    @StateObject var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .padding()
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                    
                    Text(viewModel.mode.navigationTitle)
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(TaskFormStrings.Label.taskTitle)
                        .foregroundColor(.gray)
                    
                    TextField(TaskFormStrings.Placeholder.taskTitle, text: $viewModel.title)
                        .padding()
                        .frame(height: 55)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(TaskFormStrings.Label.duration)
                        .foregroundColor(.gray)
                    
                    TextField("", text: $viewModel.durationText)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.durationText) {
                            viewModel.onDurationTextChanged($0)
                        }
                        .padding()
                        .frame(height: 55)
                        .background(Color.white)
                        .cornerRadius(14)
                }
                
                HStack(spacing: 12) {
                    ForEach([15, 25, 30, 45], id: \.self) { value in
                        DurationChip(
                            value: value,
                            isSelected: viewModel.selectedDuration == value
                        ) {
                            viewModel.selectDuration(value)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text(TaskFormStrings.Label.icon)
                        .foregroundColor(.gray)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.icons, id: \.self) { icon in
                                
                                Button {
                                    viewModel.selectedIcon = icon
                                } label: {
                                    ZStack {
                                        Circle()
                                            .fill(
                                                viewModel.selectedIcon == icon
                                                ? .main
                                                : Color.white
                                            )
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: icon.rawValue)
                                            .foregroundColor(
                                                viewModel.selectedIcon == icon
                                                ? .white
                                                : .gray
                                            )
                                    }
                                    .shadow(
                                        color: viewModel.selectedIcon == icon
                                        ? .main.opacity(0.3)
                                        : .clear,
                                        radius: 6
                                    )
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                PrimaryButton(title: viewModel.mode.buttonTitle) {
                    viewModel.save()
                }
                .disabled(!viewModel.isValid)
                .opacity(viewModel.isValid ? 1 : 0.5)
            }
            .padding(24)
        }
        .background(.customBackground)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setupInitialData()
            setupCallbacks()
        }
    }
    
    private func setupCallbacks() {
        viewModel.onSuccess = {
            dismiss()
        }
    }
}
