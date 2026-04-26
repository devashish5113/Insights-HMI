import SwiftUI

struct CycleTrendsCard: View {

    let data: CycleTrendsData

    private let pageSize: Int           = 6
    private let barHeight: CGFloat      = 140
    private let barWidth: CGFloat       = 14
    private let capsuleW: CGFloat       = 14
    private let greenCapsuleH: CGFloat  = 36
    private let pinkCapsuleH: CGFloat   = 28

    @State private var page: Int = 0

    private var totalPages: Int { max(1, Int(ceil(Double(data.bars.count) / Double(pageSize)))) }

    private var visibleBars: [CycleBar] {
        let start = page * pageSize
        let end   = min(start + pageSize, data.bars.count)
        return Array(data.bars[start..<end])
    }

    var body: some View {
        InsightCard {
            HStack(spacing: 8) {

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        page = max(0, page - 1)
                    }
                }) {
                    Image(systemName: "chevron.left.circle")
                        .font(.system(size: 20))
                        .foregroundColor(page > 0 ? Color.lavenderSoft : Color.lavenderSoft.opacity(0.3))
                }
                .disabled(page == 0)

                HStack(alignment: .bottom, spacing: 0) {
                    ForEach(visibleBars) { bar in
                        barColumn(bar)
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 8)
                .animation(.easeInOut(duration: 0.25), value: page)

                Button(action: {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        page = min(totalPages - 1, page + 1)
                    }
                }) {
                    Image(systemName: "chevron.right.circle")
                        .font(.system(size: 20))
                        .foregroundColor(page < totalPages - 1 ? Color.lavenderSoft : Color.lavenderSoft.opacity(0.3))
                }
                .disabled(page >= totalPages - 1)
            }
            .padding(.horizontal, 4)
        }
    }

    @ViewBuilder
    private func barColumn(_ bar: CycleBar) -> some View {
        VStack(spacing: 10) {

            Text("\(bar.totalDays)")
                .font(.dmSansToggleSel)
                .foregroundColor(.textPrimary)

            ZStack(alignment: .top) {
                lavenderPill
                greenCapsule(bar)
                pinkCapsule(bar)
            }
            .frame(width: barWidth, height: barHeight)

            Text(bar.month)
                .font(.dmSansAxis)
                .foregroundColor(.textSecondary)
        }
    }

    private var lavenderPill: some View {
        RoundedRectangle(cornerRadius: barWidth / 2)
            .fill(Color.lavenderSoft)
            .frame(width: barWidth, height: barHeight)
    }

    @ViewBuilder
    private func greenCapsule(_ bar: CycleBar) -> some View {
        let topPad = CGFloat(bar.greenTopOffset) * barHeight

        ZStack {
            RoundedRectangle(cornerRadius: capsuleW / 2)
                .fill(Color.sagePrimary)
                .frame(width: capsuleW, height: greenCapsuleH)

            Image("ovulation_icon")
                .resizable()
                .scaledToFit()
                .frame(width: 11, height: 11)
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(width: capsuleW, height: greenCapsuleH, alignment: .top)
        .offset(y: topPad)
    }

    @ViewBuilder
    private func pinkCapsule(_ bar: CycleBar) -> some View {
        let bottomGap = CGFloat(bar.pinkBottomOffset) * barHeight
        let topOffset = barHeight - pinkCapsuleH - bottomGap

        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: capsuleW / 2)
                .fill(Color.salmonPink)
                .frame(width: capsuleW, height: pinkCapsuleH)

            Image(systemName: "drop")
                .font(.system(size: 9, weight: .light))
                .foregroundColor(.white.opacity(0.85))
                .padding(.bottom, 5)
        }
        .frame(width: capsuleW, height: pinkCapsuleH)
        .offset(y: topOffset)
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
