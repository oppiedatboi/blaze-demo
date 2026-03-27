import SwiftUI
import UIKit

struct SlidingTabBar: View {
    @Binding var selectedTab: Tab
    var namespace: Namespace.ID

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    let changed = selectedTab != tab
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                    if changed {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: selectedTab == tab ? tab.iconFilled : tab.icon)
                            .font(.system(size: 20, weight: BlazeTheme.iconWeight))
                            .symbolRenderingMode(.hierarchical)
                            .contentTransition(.symbolEffect(.replace))

                        Text(tab.rawValue)
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(selectedTab == tab ? BlazeTheme.accent : BlazeTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background {
                        if selectedTab == tab {
                            Capsule()
                                .fill(BlazeTheme.accent.opacity(0.15))
                                .matchedGeometryEffect(id: "tab_bg", in: namespace)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background {
            RoundedRectangle(cornerRadius: 24)
                .fill(BlazeTheme.surface)
                .shadow(color: .black.opacity(0.4), radius: 12, y: -4)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}
