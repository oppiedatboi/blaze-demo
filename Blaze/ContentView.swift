import SwiftUI
import UIKit

enum Tab: String, CaseIterable {
    case today = "Today"
    case stats = "Stats"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .today: "flame"
        case .stats: "chart.bar"
        case .settings: "gearshape"
        }
    }

    var iconFilled: String {
        switch self {
        case .today: "flame.fill"
        case .stats: "chart.bar.fill"
        case .settings: "gearshape.fill"
        }
    }

    var index: Int {
        switch self {
        case .today: 0
        case .stats: 1
        case .settings: 2
        }
    }

    static func fromIndex(_ index: Int) -> Tab {
        switch index {
        case 0: .today
        case 1: .stats
        case 2: .settings
        default: .today
        }
    }
}

struct ContentView: View {
    @State private var selectedTab: Tab = .today
    @State private var dragOffset: CGFloat = 0
    @Namespace private var tabNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            BlazeTheme.background
                .ignoresSafeArea()

            GeometryReader { geo in
                let width = geo.size.width

                HStack(spacing: 0) {
                    TodayView()
                        .frame(width: width)

                    StatsView()
                        .frame(width: width)

                    SettingsView()
                        .frame(width: width)
                }
                .offset(x: -CGFloat(selectedTab.index) * width + dragOffset)
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: selectedTab)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            let threshold: CGFloat = 50
                            let velocity = value.predictedEndTranslation.width - value.translation.width
                            let currentIndex = selectedTab.index

                            withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                if value.translation.width < -threshold || velocity < -100 {
                                    selectedTab = Tab.fromIndex(min(currentIndex + 1, 2))
                                } else if value.translation.width > threshold || velocity > 100 {
                                    selectedTab = Tab.fromIndex(max(currentIndex - 1, 0))
                                }
                                dragOffset = 0
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        }
                )
            }
            .ignoresSafeArea(edges: .bottom)

            SlidingTabBar(selectedTab: $selectedTab, namespace: tabNamespace)
        }
    }
}
