import PomorCore
import PomorDesignSystem
import SwiftUI

enum TaskFormMode: Hashable {
    case create
    case edit(PomTask)

    var navigationTitle: String {
        switch self {
        case .create: return "New Session"
        case .edit:   return "Edit Session"
        }
    }

    var buttonTitle: String {
        switch self {
        case .create: return "Create Session"
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
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.pomor(.brand))
                            .frame(width: 44, height: 44)
                            .background(.pomor(.surface))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)

                    Text(viewModel.mode.navigationTitle)
                        .pomorFont(.screenTitle)
                        .pomorForeground(.textPrimary)

                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(TaskFormStrings.Label.taskTitle)
                        .pomorFont(.label)
                        .pomorForeground(.textTertiary)

                    TextField(TaskFormStrings.Placeholder.taskTitle, text: $viewModel.title)
                        .pomorFont(.placeholder)
                        .pomorForeground(.textPrimary)
                        .padding()
                        .frame(height: 55)
                        .background(.pomor(.surface))
                        .cornerRadius(14)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(TaskFormStrings.Label.duration)
                        .pomorFont(.label)
                        .pomorForeground(.textTertiary)

                    TextField("", text: $viewModel.durationText)
                        .pomorFont(.body)
                        .pomorForeground(.textPrimary)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.durationText) {
                            viewModel.onDurationTextChanged($0)
                        }
                        .padding()
                        .frame(height: 55)
                        .background(.pomor(.surface))
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
                        .pomorFont(.label)
                        .pomorForeground(.textTertiary)

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
                                                ? Color.pomor(.brand)
                                                : Color.pomor(.surface)
                                            )
                                            .frame(width: 50, height: 50)

                                        Image(systemName: icon.rawValue)
                                            .foregroundStyle(
                                                viewModel.selectedIcon == icon
                                                ? Color.pomor(.onBrand)
                                                : Color.pomor(.textTertiary)
                                            )
                                    }
                                    .shadow(
                                        color: viewModel.selectedIcon == icon
                                        ? Color.pomor(.brandShadow)
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
        .background(.pomor(.background))
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
