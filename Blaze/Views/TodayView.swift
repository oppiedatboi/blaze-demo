import SwiftUI
import SwiftData
import UIKit

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showAddHabit = false
    @State private var confettiHabitID: PersistentIdentifier?
    @State private var showEmptyState = false

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                if habits.isEmpty {
                    emptyState
                } else {
                    habitList
                }
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddHabit = true
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24, weight: BlazeTheme.iconWeight))
                            .foregroundStyle(BlazeTheme.accent)
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView()
            }
            .overlay {
                if confettiHabitID != nil {
                    ConfettiView()
                        .allowsHitTesting(false)
                        .ignoresSafeArea()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            FoxMascot()
                .frame(width: 180, height: 180)
                .scaleEffect(showEmptyState ? 1.0 : 0.7)
                .opacity(showEmptyState ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showEmptyState)

            Text("No habits yet!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(BlazeTheme.textPrimary)
                .opacity(showEmptyState ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2), value: showEmptyState)

            Text("Tap + to start building\nyour daily streak")
                .font(.subheadline)
                .foregroundStyle(BlazeTheme.textSecondary)
                .multilineTextAlignment(.center)
                .opacity(showEmptyState ? 1.0 : 0.0)
                .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.35), value: showEmptyState)

            Button {
                showAddHabit = true
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            } label: {
                Label("Add First Habit", systemImage: "plus")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(BlazeTheme.accent, in: Capsule())
            }
            .scaleEffect(showEmptyState ? 1.0 : 0.8)
            .opacity(showEmptyState ? 1.0 : 0.0)
            .offset(y: showEmptyState ? 0 : 20)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.5), value: showEmptyState)
        }
        .padding(.bottom, 80)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showEmptyState = true
            }
        }
    }

    private var habitList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(habits) { habit in
                    HabitRow(habit: habit, onToggle: {
                        let wasCompleted = habit.isCompletedToday
                        habit.toggleToday(context: context)
                        if !wasCompleted {
                            confettiHabitID = habit.persistentModelID
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                confettiHabitID = nil
                            }
                        }
                    }, onDelete: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                            context.delete(habit)
                        }
                    })
                    .contextMenu {
                        Button(role: .destructive) {
                            UINotificationFeedbackGenerator().notificationOccurred(.warning)
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                                context.delete(habit)
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .scale(scale: 0.0).combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }
}
