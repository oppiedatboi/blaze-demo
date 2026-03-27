import SwiftUI
import SwiftData
import UIKit

struct AddHabitView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "FF6B35"
    @State private var iconBounce: String?
    @State private var colorBounce: String?

    private let icons = [
        "star.fill", "heart.fill", "book.fill", "figure.run",
        "drop.fill", "moon.fill", "brain.head.profile", "dumbbell.fill",
        "cup.and.saucer.fill", "pencil.line", "music.note", "leaf.fill",
        "pills.fill", "bed.double.fill", "fork.knife", "bicycle"
    ]

    private let colors = [
        "FF6B35", "FF9F1C", "4CAF50", "2196F3",
        "9C27B0", "E91E63", "00BCD4", "FF5722"
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        // Preview
                        VStack(spacing: 12) {
                            Image(systemName: selectedIcon)
                                .font(.system(size: 44, weight: BlazeTheme.iconWeight))
                                .foregroundStyle(Color(hex: selectedColor))
                                .frame(width: 80, height: 80)
                                .background(Color(hex: selectedColor).opacity(0.15), in: RoundedRectangle(cornerRadius: 20))
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedIcon)
                                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedColor)

                            Text(name.isEmpty ? "New Habit" : name)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textPrimary)
                        }
                        .padding(.top, 8)

                        // Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NAME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textSecondary)

                            TextField("e.g. Morning Run", text: $name)
                                .textFieldStyle(.plain)
                                .padding(14)
                                .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.smallRadius))
                                .foregroundStyle(BlazeTheme.textPrimary)
                        }

                        // Icon picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ICON")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textSecondary)

                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                                ForEach(icons, id: \.self) { icon in
                                    Button {
                                        selectedIcon = icon
                                        UISelectionFeedbackGenerator().selectionChanged()
                                        iconBounce = icon
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            iconBounce = nil
                                        }
                                    } label: {
                                        Image(systemName: icon)
                                            .font(.system(size: 22, weight: BlazeTheme.iconWeight))
                                            .frame(width: 50, height: 50)
                                            .background(
                                                selectedIcon == icon
                                                    ? Color(hex: selectedColor).opacity(0.2)
                                                    : BlazeTheme.surface,
                                                in: RoundedRectangle(cornerRadius: BlazeTheme.smallRadius)
                                            )
                                            .overlay(
                                                RoundedRectangle(cornerRadius: BlazeTheme.smallRadius)
                                                    .strokeBorder(
                                                        selectedIcon == icon ? Color(hex: selectedColor) : .clear,
                                                        lineWidth: 2
                                                    )
                                            )
                                            .scaleEffect(iconBounce == icon ? 1.05 : (selectedIcon == icon ? 1.0 : 0.95))
                                            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: iconBounce)
                                    }
                                    .foregroundStyle(selectedIcon == icon ? Color(hex: selectedColor) : BlazeTheme.textSecondary)
                                }
                            }
                        }

                        // Color picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("COLOR")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textSecondary)

                            HStack(spacing: 12) {
                                ForEach(colors, id: \.self) { color in
                                    Button {
                                        selectedColor = color
                                        UISelectionFeedbackGenerator().selectionChanged()
                                        colorBounce = color
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            colorBounce = nil
                                        }
                                    } label: {
                                        Circle()
                                            .fill(Color(hex: color))
                                            .frame(width: 36, height: 36)
                                            .overlay {
                                                if selectedColor == color {
                                                    Circle()
                                                        .strokeBorder(.white, lineWidth: 3)
                                                }
                                            }
                                            .scaleEffect(colorBounce == color ? 1.15 : 1.0)
                                            .animation(.spring(response: 0.25, dampingFraction: 0.5), value: colorBounce)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        dismiss()
                    }
                    .foregroundStyle(BlazeTheme.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let habit = Habit(name: name, icon: selectedIcon, colorHex: selectedColor)
                        context.insert(habit)
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(BlazeTheme.accent)
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationDetents([.fraction(0.85)])
        .presentationCornerRadius(28)
        .presentationBackground(BlazeTheme.background)
    }
}
