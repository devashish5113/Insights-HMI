import SwiftUI

struct InsightsView: View {

    @State private var selectedTab: BottomNavBar.Tab = .insights
    @State private var weightPeriod: BodyMetabolicCard.Period = .monthly
    @State private var lifestylePeriod: String = "4 months"

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backgroundMint.ignoresSafeArea()

            
            
            VStack {
                HStack {
                    Spacer()
                    Circle()
                        .fill(Color.salmonPink.opacity(0.15))
                        .frame(width: 300, height: 300)
                        .blur(radius: 60) 
                        .offset(x: 100, y: -50)
                }
                Spacer()
            }
            .ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    navigationHeader
                        .padding(.top, 12)
                        .padding(.bottom, 20)

                    SectionHeader(title: "Stability Summary")
                        .padding(.bottom, 10)
                    StabilitySummaryCard(data: .sample)

                    sectionSpacer

                    SectionHeader(title: "Cycle Trends")
                        .padding(.bottom, 10)
                    CycleTrendsCard(data: .sample)

                    sectionSpacer

                    SectionHeader(title: "Body & Metabolic Trends")
                        .padding(.bottom, 10)
                    BodyMetabolicCard(
                        data: weightPeriod == .monthly ? .monthlySample : .weeklySample,
                        selectedPeriod: $weightPeriod
                    )

                    sectionSpacer

                    SectionHeader(title: "Body Signals")
                        .padding(.bottom, 10)
                    BodySignalsCard(slices: .sample)

                    sectionSpacer

                    SectionHeader(title: "Lifestyle Impact")
                        .padding(.bottom, 10)
                    LifestyleImpactCard(rows: .sample, selectedPeriod: $lifestylePeriod)

                    Spacer().frame(height: 100)
                }
            }

            BottomNavBar(selectedTab: $selectedTab)
        }
        .navigationBarHidden(true)
    }

    

    private var navigationHeader: some View {
        ZStack {
            Text("Insights")
                .font(.dmSansNavigationHead)
                .tracking(-20 * 0.02)
                .foregroundColor(.textPrimary)
            

            HStack {
                GridLogo()
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }

    

    struct GridLogo: View {
        var body: some View {
            VStack(spacing: 4) {
                HStack(spacing: 4) {
                    Circle().fill(Color.lavenderSoft).frame(width: 8, height: 8)
                    Circle().fill(Color.lavenderLightest).frame(width: 8, height: 8)
                }
                HStack(spacing: 4) {
                    Circle().fill(Color.lavenderLightest).frame(width: 8, height: 8)
                    Circle().fill(Color.lavenderSoft).frame(width: 8, height: 8)
                }
            }
        }
    }

    private var sectionSpacer: some View {
        Spacer().frame(height: 32)
    }
}

#Preview {
    InsightsView()
}
