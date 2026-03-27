import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                List {
                    Section {
                        HStack(spacing: 14) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 28, weight: BlazeTheme.iconWeight))
                                .foregroundStyle(BlazeTheme.accent)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Blaze")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundStyle(BlazeTheme.textPrimary)

                                Text("Build habits that stick")
                                    .font(.caption)
                                    .foregroundStyle(BlazeTheme.textSecondary)
                            }
                        }
                        .listRowBackground(BlazeTheme.surface)
                    }

                    Section("General") {
                        HStack {
                            Label("Habits", systemImage: "list.bullet")
                                .foregroundStyle(BlazeTheme.textPrimary)
                            Spacer()
                            Text("\(habits.count)")
                                .foregroundStyle(BlazeTheme.textSecondary)
                        }
                        .listRowBackground(BlazeTheme.surface)

                        HStack {
                            Label("Version", systemImage: "info.circle")
                                .foregroundStyle(BlazeTheme.textPrimary)
                            Spacer()
                            Text("1.0.0")
                                .foregroundStyle(BlazeTheme.textSecondary)
                        }
                        .listRowBackground(BlazeTheme.surface)

                        HStack {
                            Label("iOS Requirement", systemImage: "iphone")
                                .foregroundStyle(BlazeTheme.textPrimary)
                            Spacer()
                            Text("17.0+")
                                .foregroundStyle(BlazeTheme.textSecondary)
                        }
                        .listRowBackground(BlazeTheme.surface)
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
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all habits and their history. This cannot be undone.")
            }
        }
    }
}
