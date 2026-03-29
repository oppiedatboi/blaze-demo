import SwiftUI
import SwiftData
import UIKit

struct TodayView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showAddHabit = false
    @State private var confettiHabitID: PersistentIdentifier?
    @State private var showEmptyState = false
    @State private var cardAppeared = false
    @State private var isLoading = true
    @State private var showDateLabel = false
    @State private var sheetBackgroundScale: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            ZStack {
                BlazeTheme.background.ignoresSafeArea()

                if habits.isEmpty && !isLoading {
                    emptyState
                } else if isLoading {
                    loadingShimmer
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
            .safeAreaInset(edge: .top) {
                // Date context below title
                if !habits.isEmpty {
                    Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                        .font(.subheadline)
                        .foregroundStyle(BlazeTheme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, -8)
                        .opacity(showDateLabel ? 1.0 : 0.0)
                        .animation(.easeIn(duration: 0.4), value: showDateLabel)
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
            .onChange(of: showAddHabit) { _, isPresented in
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    sheetBackgroundScale = isPresented ? 0.95 : 1.0
                }
                if !isPresented {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .scaleEffect(sheetBackgroundScale)
            .onAppear {
                showDateLabel = true
                // Brief loading shimmer
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isLoading = false
                    }
                    // Re-trigger staggered entrance
                    cardAppeared = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        cardAppeared = true
                    }
                }
            }
        }
    }

    private var loadingShimmer: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(0..<4, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: BlazeTheme.cardRadius)
                        .fill(BlazeTheme.surface)
                        .frame(height: 72)
                        .shimmer()
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 24) {
            PitbullMascotView(pose: .sleeping, size: 180)
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
                ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
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
                        UINotificationFeedbackGenerator().notificationOccurred(.warning)
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
                    .opacity(cardAppeared ? 1.0 : 0.0)
                    .offset(y: cardAppeared ? 0 : 20)
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.7)
                        .delay(Double(index) * 0.08),
                        value: cardAppeared
                    )
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
