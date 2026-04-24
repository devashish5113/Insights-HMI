
import SwiftUI
import Charts

struct StabilitySummaryCard: View {

    @State var data: StabilityData
    @State private var activeIndex: Int = 2

    var body: some View {
        InsightCard {
            ZStack(alignment: .topTrailing) {

                Circle()
                    .fill(Color.sagePrimary.opacity(0.25))
                    .frame(width: 200, height: 200)
                    .blur(radius: 60)
                    .offset(x: 50, y: 20)

                VStack(alignment: .leading, spacing: 20) {

                    Text(data.subtitle)
                        .font(.dmSansBody)
                        .foregroundColor(.textSecondary)
                        .lineSpacing(4)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Stability Score")
                            .font(.dmSansStatLabel)
                            .tracking(-18 * 0.02)
                            .lineSpacing(0)
                            .foregroundColor(.textPrimary)

                        Text("\(data.score)%")
                            .font(.dmSansStatValue)
                            .foregroundColor(.textPrimary)
                    }

                    stabilityChart
                        .frame(height: 160)
                        .padding(.top, 10)
                }
                .padding(.vertical, 8)
            }
        }
    }

    private var stabilityChart: some View {
        ZStack(alignment: .topLeading) {
            Chart {

                ForEach(data.bandPoints) { pt in
                    AreaMark(
                        x: .value("Month", pt.month),
                        yStart: .value("Lower", pt.lower),
                        yEnd: .value("Upper", pt.upper)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 183/255, green: 160/255, blue: 240/255).opacity(0.55),
                                Color(red: 183/255, green: 160/255, blue: 240/255).opacity(0.10)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.linear)
                }

                ForEach(data.bandPoints) { pt in
                    AreaMark(
                        x: .value("Month", pt.month),
                        yStart: .value("Lower", pt.lower),
                        yEnd: .value("Mid", pt.mid)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 140/255, green: 110/255, blue: 200/255).opacity(0.65),
                                Color(red: 140/255, green: 110/255, blue: 200/255).opacity(0.20)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.linear)
                }

                ForEach(data.bandPoints) { pt in
                    AreaMark(
                        x: .value("Month", pt.month),
                        yStart: .value("Floor", 23.5),
                        yEnd: .value("Lower", pt.lower)
                    )
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 100/255, green: 75/255, blue: 160/255).opacity(0.50),
                                Color(red: 100/255, green: 75/255, blue: 160/255).opacity(0.08)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.linear)
                }

                RuleMark(x: .value("Month", data.bandPoints[activeIndex].month))
                    .foregroundStyle(Color.sagePrimary.opacity(0.5))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4]))

                PointMark(
                    x: .value("Month", data.bandPoints[activeIndex].month),
                    y: .value("Days", data.bandPoints[activeIndex].mid)
                )
                .foregroundStyle(Color.sagePrimary)
                .symbolSize(120)
            }
            .chartYScale(domain: 23.5...35)
            .chartXAxis {
                AxisMarks(values: .automatic) {
                    AxisValueLabel()
                        .font(.dmSansAxis)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [24, 28, 32]) { value in
                    AxisValueLabel {
                        if let v = value.as(Int.self) {
                            Text("\(v)d")
                                .font(.dmSansAxis)
                                .foregroundStyle(Color.textSecondary)
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geo in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let x = value.location.x - geo[proxy.plotAreaFrame].origin.x
                                    if let month: String = proxy.value(atX: x) {
                                        if let index = data.bandPoints.firstIndex(where: { $0.month == month }) {
                                            withAnimation(.interactiveSpring()) {
                                                activeIndex = index
                                            }
                                        }
                                    }
                                }
                        )
                }
            }

            GeometryReader { geo in
                let chartWidth = geo.size.width
                let xFraction = Double(activeIndex) / Double(data.bandPoints.count - 1)
                let xPos = chartWidth * xFraction

                VStack(spacing: 0) {
                    Text(data.chartPoints[min(activeIndex, data.chartPoints.count - 1)].status)
                        .font(.dmSansToggle)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color.tooltipDark)
                        .cornerRadius(10)

                    Triangle()
                        .fill(Color.tooltipDark)
                        .frame(width: 14, height: 8)
                }
                .offset(x: xPos - 45, y: -20)
            }
        }
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Stability Summary")
            StabilitySummaryCard(data: .sample)
        }
        .padding(.vertical)
    }
    .background(Color.backgroundMint)
}
