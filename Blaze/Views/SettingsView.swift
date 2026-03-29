import SwiftUI
import SwiftData
import UIKit

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showDeleteAlert = false
    @State private var showRows = false

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                List {
                    // Pitbull mascot header
                    Section {
                        VStack(spacing: 12) {
                            PitbullMascotView(pose: .reading, size: 100)

                            VStack(spacing: 4) {
                                Text("Blaze")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(BlazeTheme.textPrimary)

                                Text("Build habits that stick")
                                    .font(.caption)
                                    .foregroundStyle(BlazeTheme.textSecondary)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .listRowBackground(BlazeTheme.surface)
                    }

                    Section("General") {
                        settingsRow(icon: "list.bullet", title: "Habits", detail: "\(habits.count)", index: 0)
                        settingsRow(icon: "info.circle", title: "Version", detail: "3.0.0", index: 1)
                        settingsRow(icon: "iphone", title: "iOS Requirement", detail: "17.0+", index: 2)
                    }

                    Section("Actions") {
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            Label("Rate on App Store", systemImage: "star")
                                .foregroundStyle(BlazeTheme.textPrimary)
                        }
                        .listRowBackground(BlazeTheme.surface)
                        .opacity(showRows ? 1.0 : 0.0)
                        .offset(x: showRows ? 0 : -20)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.35), value: showRows)

                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            let activityVC = UIActivityViewController(
                                activityItems: ["Check out Blaze — a habit tracker that helps you build streaks!"],
                                applicationActivities: nil
                            )
                            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                               let rootVC = windowScene.windows.first?.rootViewController {
                                rootVC.present(activityVC, animated: true)
                            }
                        } label: {
                            Label("Share with Friends", systemImage: "square.and.arrow.up")
                                .foregroundStyle(BlazeTheme.textPrimary)
                        }
                        .listRowBackground(BlazeTheme.surface)
                        .opacity(showRows ? 1.0 : 0.0)
                        .offset(x: showRows ? 0 : -20)
                        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.45), value: showRows)
                    }

                    Section("Widget") {
                        Label("Add the Blaze widget to your Home Screen to see your streaks at a glance.", systemImage: "widget.small")
                            .font(.subheadline)
                            .foregroundStyle(BlazeTheme.textSecondary)
                            .listRowBackground(BlazeTheme.surface)
                    }

                    Section("Data") {
                        Button(role: .destructive) {
                            showDeleteAlert = true
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                        } label: {
                            Label("Delete All Habits", systemImage: "trash")
                        }
                        .listRowBackground(BlazeTheme.surface)
                    }
                }
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("Delete All Habits?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    for habit in habits {
                        context.delete(habit)
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all habits and their history. This cannot be undone.")
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showRows = true
                }
            }
        }
    }

    @ViewBuilder
    private func settingsRow(icon: String, title: String, detail: String, index: Int) -> some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundStyle(BlazeTheme.textPrimary)
            Spacer()
            Text(detail)
                .foregroundStyle(BlazeTheme.textSecondary)
        }
        .listRowBackground(BlazeTheme.surface)
        .opacity(showRows ? 1.0 : 0.0)
        .offset(x: showRows ? 0 : -20)
        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(0.1 + Double(index) * 0.1), value: showRows)
    }
}
