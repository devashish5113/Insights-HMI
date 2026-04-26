import SwiftUI

struct BottomNavBar: View {
    
    @Binding var selectedTab: Tab

    enum Tab: String, CaseIterable {
        case home     = "Home"
        case track    = "Track"
        case insights = "Insights"
    }
    
    private func iconName(for tab: Tab) -> String {
        switch tab {
        case .home:     return "house"
        case .track:    return "clock"
        case .insights: return "chart.bar"
        }
    }
    
    var body: some View {
        HStack(spacing: 12) {

            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    tabItem(tab)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 60)
            .background(
                ZStack {
                    
                    Capsule()
                        .fill(.ultraThinMaterial)
                    
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.4),
                                    .white.opacity(0.1),
                                    .clear,
                                    .black.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.6), .white.opacity(0.1), .black.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 10)
            .shadow(color: .black.opacity(0.04), radius: 1, x: 0, y: 1)

            
            Button { } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                    
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.white.opacity(0.4), .clear, .black.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.08), radius: 15, x: 0, y: 10)

                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.black.opacity(0.6))
                }
                .frame(width: 60, height: 60)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 34) 
    }

    

    @ViewBuilder
    private func tabItem(_ tab: Tab) -> some View {
        let isActive = selectedTab == tab

        Button {
            withAnimation(.easeInOut(duration: 0.18)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: iconName(for: tab))
                    .font(.system(size: 18, weight: isActive ? .semibold : .regular))

                Text(tab.rawValue)
                    .font(.dmSansAxis)
            }
            .foregroundColor(.black.opacity(isActive ? 1.0 : 0.4))
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack(alignment: .bottom) {
        Color.backgroundMint.ignoresSafeArea()
        BottomNavBar(selectedTab: .constant(.insights))
    }
}
