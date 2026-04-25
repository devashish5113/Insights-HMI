

import SwiftUI
import Charts

struct BodyMetabolicCard: View {

    let data: WeightData
    @Binding var selectedPeriod: Period

    enum Period: String, CaseIterable {
        case monthly = "Monthly"
        case weekly  = "Weekly"
    }

    var body: some View {
        InsightCard {
            VStack(spacing: 16) {

                
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Your weight")
                            .font(.dmSansCardSub)
                            .tracking(-16 * 0.02)
                            .lineSpacing(0)
                            .foregroundColor(.textPrimary)
                        Text("in kg")
                            .font(.dmSansSmall)
                            .foregroundColor(.textSecondary)
                    }

                    Spacer()

                    
                    periodToggle
                }

                
                weightChart
                    .frame(height: 180)
            }
        }
    }

    

    private var periodToggle: some View {
        HStack(spacing: 0) {
            ForEach(Period.allCases, id: \.self) { period in
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedPeriod = period
                    }
                } label: {
                    Text(period.rawValue)
                        .font(selectedPeriod == period ? .dmSansToggleSel : .dmSansToggle)
                        .foregroundColor(selectedPeriod == period ? .white : .textSecondary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 9)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPeriod == period ? Color.black : Color.pillBackground)
                        )
                }
                .buttonStyle(.plain)
            }
        }
    }

    

    private var weightChart: some View {
        Chart {

            ForEach(data.points) { point in
                AreaMark(
                    x: .value("Month", point.month),
                    yStart: .value("Base", 25),
                    yEnd: .value("kg", point.kg)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.weightPink.opacity(0.4), Color.weightPink.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }

            ForEach(data.points) { point in
                LineMark(
                    x: .value("Month", point.month),
                    y: .value("kg", point.kg)
                )
                .foregroundStyle(Color.weightPink)
                .lineStyle(StrokeStyle(lineWidth: 2))
                .interpolationMethod(.catmullRom)
            }
        }
        .chartYScale(domain: yMin...yMax)
        .chartXAxis {
            AxisMarks(values: .automatic) {
                AxisValueLabel()
                    .font(.dmSansAxis)
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: [25, 50, 75]) { value in
                AxisValueLabel {
                    if let v = value.as(Int.self) {
                        Text("\(v)")
                            .font(.dmSansAxis)
                            .foregroundStyle(Color.textSecondary)
                    }
                }
                AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    .foregroundStyle(Color.heatmapEmpty)
            }
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                let plotOrigin = geo[proxy.plotAreaFrame].origin
                ForEach(data.points) { point in
                    if let xPos = proxy.position(forX: point.month),
                       let yPos = proxy.position(forY: point.kg) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                            Circle()
                                .fill(Color.salmonPink)
                                .frame(width: 5, height: 5)
                        }
                        .position(
                            x: plotOrigin.x + xPos,
                            y: plotOrigin.y + yPos
                        )
                    }
                }
            }
        }
    }

    private var yMin: Double { 20 }
    private var yMax: Double { 80 }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Body & Metabolic Trends")
            BodyMetabolicCard(data: .monthlySample, selectedPeriod: .constant(.monthly))
        }
        .padding(.vertical)
    }
    .background(Color.backgroundMint)
}
