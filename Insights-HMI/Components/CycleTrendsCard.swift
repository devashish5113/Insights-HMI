

import SwiftUI

struct CycleTrendsCard: View {

    let data: CycleTrendsData

    
    private let maxBarHeight: CGFloat = 140

    var body: some View {
        InsightCard {
            HStack(spacing: 12) {
                
                Button(action: {}) {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color.lavenderSoft)
                }

                
                
                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(data.bars) { bar in
                        barColumn(bar)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 8)

                
                Button(action: {}) {
                    Image(systemName: "chevron.right.circle")
                        .font(.system(size: 20))
                        .foregroundColor(Color.lavenderSoft)
                }
            }
            .padding(.horizontal, 4)
        }
    }

    

    @ViewBuilder
    private func barColumn(_ bar: CycleBar) -> some View {
        VStack(spacing: 12) {
            
            Text("\(bar.totalDays)")
                .font(.dmSansToggleSel)
                .foregroundColor(.textPrimary)

            
            ZStack(alignment: .bottom) {
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.heatmapEmpty.opacity(0.3))
                    .frame(width: 14, height: maxBarHeight)

                segmentedBar(bar)
                    .frame(width: 14, height: maxBarHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            
            Text(bar.month)
                .font(.dmSansAxis)
                .foregroundColor(.textSecondary)
        }
    }

    @ViewBuilder
    private func segmentedBar(_ bar: CycleBar) -> some View {
        GeometryReader { geo in
            let h = geo.size.height
            VStack(spacing: 0) {
                Color.lavenderSoft.frame(height: h * bar.lavenderFraction)
                Color.sagePrimary.frame(height: h * bar.greenFraction)
                Color.salmonPink.frame(height: h * bar.pinkFraction)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Cycle Trends")
            CycleTrendsCard(data: .sample)
        }
        .padding(.vertical)
    }
    .background(Color.backgroundMint)
}
