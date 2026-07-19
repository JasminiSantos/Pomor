import SwiftUI

enum TaskDurationPresets {
    static let values = [15, 25, 30, 45]
}

struct DurationPresetPicker: View {
    var presets: [Int] = TaskDurationPresets.values
    let selected: Int?
    let onSelect: (Int) -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach(presets, id: \.self) { value in
                DurationChip(
                    value: value,
                    isSelected: selected == value,
                    action: { onSelect(value) }
                )
            }
        }
    }
}
