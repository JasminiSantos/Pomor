import PomorCore
import PomorDesignSystem
import SwiftUI

struct TaskFormView: View {

    @StateObject var viewModel: TaskFormViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            NavigationHeader(title: viewModel.mode.navigationTitle)

            FormTextField(
                label: TaskFormStrings.Label.taskTitle,
                placeholder: TaskFormStrings.Placeholder.taskTitle,
                text: $viewModel.title
            )

            FormTextField(
                label: TaskFormStrings.Label.duration,
                text: $viewModel.durationText,
                keyboardType: .numberPad,
                onTextChange: viewModel.onDurationTextChanged
            )

            DurationPresetPicker(
                selected: viewModel.selectedDuration,
                onSelect: viewModel.selectDuration
            )

            IconSelector(
                icons: viewModel.icons,
                selection: $viewModel.selectedIcon
            )

            Spacer()

            PrimaryButton(title: viewModel.mode.buttonTitle) {
                viewModel.save()
            }
            .disabled(!viewModel.isValid)
            .opacity(viewModel.isValid ? 1 : 0.5)
        }
        .padding(24)
        .background(.pomor(.background))
        .navigationBarHidden(true)
        .onAppear {
            viewModel.setupInitialData()
            viewModel.onSuccess = { dismiss() }
        }
    }
}
