import SwiftUI
import SwiftData
import UIKit

struct SuggestionChip: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

private let suggestionChips: [SuggestionChip] = [
    SuggestionChip(name: "Morning Run", icon: "figure.run"),
    SuggestionChip(name: "Read 30min", icon: "book.fill"),
    SuggestionChip(name: "Drink Water", icon: "drop.fill"),
    SuggestionChip(name: "Meditate", icon: "brain.head.profile"),
    SuggestionChip(name: "No Phone", icon: "iphone.slash"),
    SuggestionChip(name: "Sleep by 11", icon: "moon.fill"),
]

struct AddHabitView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "FF6B35"
    @State private var iconBounce: String?
    @State private var colorBounce: String?
    @State private var showVoiceOverlay = false
    @State private var chipsAppeared = false
    @State private var chipBounce: UUID?
    @State private var dragIndicatorPulse: CGFloat = 1.0

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

                        // Name with mic button
                        VStack(alignment: .leading, spacing: 8) {
                            Text("NAME")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textSecondary)

                            HStack(spacing: 10) {
                                TextField("e.g. Morning Run", text: $name)
                                    .textFieldStyle(.plain)
                                    .padding(14)
                                    .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.smallRadius))
                                    .foregroundStyle(BlazeTheme.textPrimary)

                                Button {
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                    showVoiceOverlay = true
                                } label: {
                                    Image(systemName: "mic.fill")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(BlazeTheme.accent)
                                        .frame(width: 48, height: 48)
                                        .background(BlazeTheme.surface, in: RoundedRectangle(cornerRadius: BlazeTheme.smallRadius))
                                }
                            }
                        }

                        // Suggestion Chips
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SUGGESTIONS")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundStyle(BlazeTheme.textSecondary)

                            FlowLayout(spacing: 8) {
                                ForEach(Array(suggestionChips.enumerated()), id: \.element.id) { index, chip in
                                    Button {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        name = chip.name
                                        selectedIcon = chip.icon
                                        chipBounce = chip.id
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            chipBounce = nil
                                        }
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: chip.icon)
                                                .font(.system(size: 12, weight: .medium))
                                            Text(chip.name)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                        .foregroundStyle(BlazeTheme.textPrimary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .background(BlazeTheme.surface, in: Capsule())
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(BlazeTheme.surfaceLight, lineWidth: 1)
                                        )
                                    }
                                    .scaleEffect(chipBounce == chip.id ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.25, dampingFraction: 0.5), value: chipBounce)
                                    .opacity(chipsAppeared ? 1.0 : 0.0)
                                    .offset(y: chipsAppeared ? 0 : 10)
                                    .animation(
                                        .spring(response: 0.4, dampingFraction: 0.7)
                                        .delay(Double(index) * 0.08),
                                        value: chipsAppeared
                                    )
                                }
                            }
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

                // Voice overlay
                if showVoiceOverlay {
                    VoiceInputOverlay(
                        isPresented: $showVoiceOverlay,
                        text: $name,
                        onComplete: {}
                    )
                    .transition(.opacity)
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
        .onAppear {
            // Pulse drag indicator
            withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
                dragIndicatorPulse = 1.2
            }
            withAnimation(.easeInOut(duration: 0.3).delay(0.8)) {
                dragIndicatorPulse = 1.0
            }
            // Stagger chips in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                chipsAppeared = true
            }
        }
    }
}

// MARK: - Flow Layout for suggestion chips
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = layout(in: proposal.width ?? 0, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = layout(in: bounds.width, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y),
                proposal: ProposedViewSize(subviews[index].sizeThatFits(.unspecified))
            )
        }
    }

    private func layout(in width: CGFloat, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxWidth: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > width && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxWidth = max(maxWidth, x)
        }

        return (CGSize(width: maxWidth, height: y + rowHeight), positions)
    }
}
