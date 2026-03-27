import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .today
    @Namespace private var tabNamespace

    var body: some View {
        ZStack(alignment: .bottom) {
            BlazeTheme.background
                .ignoresSafeArea()

            TabView(selection: $selectedTab) {
                TodayView()
                    .tag(Tab.today)

                StatsView()
                    .tag(Tab.stats)

                SettingsView()
                    .tag(Tab.settings)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea(edges: .bottom)

            SlidingTabBar(selectedTab: $selectedTab, namespace: tabNamespace)
        }
    }
}

enum Tab: String, CaseIterable {
    case today = "Today"
    case stats = "Stats"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .today: "flame.fill"
        case .stats: "chart.bar.fill"
        case .settings: "gearshape.fill"
        }
    }
}
