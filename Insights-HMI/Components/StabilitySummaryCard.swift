
import SwiftUI

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
                            .foregroundColor(.textPrimary)

                        Text("\(data.score)%")
                            .font(.dmSansStatValue)
                            .foregroundColor(.textPrimary)
                    }

                    StabilityBandChart(
                        chartPoints: data.chartPoints,
                        activeIndex: $activeIndex
                    )
                    .frame(height: 170)
                    .padding(.top, 10)
                }
                .padding(.vertical, 8)
            }
        }
    }
}

private struct StabilityBandChart: View {

    let chartPoints: [CyclePoint]
    @Binding var activeIndex: Int

    private let leftPad: CGFloat   = 36
    private let bottomPad: CGFloat = 22
    private let sampleCount: Int   = 40

    private let outerColor          = Color(red: 230/255, green: 224/255, blue: 251/255)
    private let innerColor          = Color(red: 180/255, green: 168/255, blue: 218/255)
    private let outerHighlightColor = Color(red: 183/255, green: 165/255, blue: 232/255)
    private let innerHighlightColor = Color(red: 130/255, green: 108/255, blue: 188/255)
    private let dotColor            = Color(red: 110/255, green: 140/255, blue: 130/255)

    private var yMin: Double { (chartPoints.map(\.value).min() ?? 20) - 1.5 }
    private var yMax: Double { (chartPoints.map(\.value).max() ?? 35) + 2.5 }

    private var yLabels: [(Double, String)] {
        let lo = (yMin / 4).rounded(.up) * 4
        return stride(from: lo, through: yMax, by: 4).map { v in
            (v, "\(Int(v))d")
        }
    }

    var body: some View {
        GeometryReader { geo in
            let pw = geo.size.width - leftPad
            let ph = geo.size.height - bottomPad

            ZStack(alignment: .topLeading) {

                Canvas { ctx, _ in
                    drawGrid(&ctx, pw: pw, ph: ph)
                    drawBands(&ctx, pw: pw, ph: ph)
                    drawRule(&ctx, pw: pw, ph: ph)
                }
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { v in
                            let rawX = v.location.x - leftPad
                            let idx = Int(
                                (max(0, min(1, rawX / pw))
                                 * CGFloat(chartPoints.count - 1)).rounded()
                            )
                            withAnimation(.interactiveSpring()) { activeIndex = idx }
                        }
                )

                yAxisOverlay(ph: ph)
                xAxisOverlay(pw: pw, ph: ph)
                tooltipOverlay(pw: pw, ph: ph)
            }
        }
    }

    private func xp(_ t: CGFloat, pw: CGFloat) -> CGFloat { leftPad + t * pw }

    private func yp(_ v: Double, ph: CGFloat) -> CGFloat {
        CGFloat((yMax - v) / (yMax - yMin)) * ph
    }

    private func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double {
        a + (b - a) * t
    }

    private func upperY(at t: Double) -> Double {
        let v0 = chartPoints.first?.value ?? yMin
        let v1 = chartPoints.last?.value  ?? yMax
        let k  = 3.0
        let ek = exp(k)
        let A  = (v1 - v0) / (ek - 1.0)
        let C  = v0 - A
        return A * exp(k * t) + C
    }

    private func lowerY(at t: Double) -> Double {
        let baseMin = chartPoints.map(\.value).min() ?? yMin
        return baseMin - 0.4
    }

    private func midUpperY(at t: Double) -> Double {
        let u = upperY(at: t)
        let l = lowerY(at: t)
        return lerp(l, u, 0.62)
    }

    private func midLowerY(at t: Double) -> Double {
        let u = upperY(at: t)
        let l = lowerY(at: t)
        return lerp(l, u, 0.28)
    }

    private func drawGrid(_ ctx: inout GraphicsContext, pw: CGFloat, ph: CGFloat) {
        var p = Path()
        for (val, _) in yLabels {
            let gy = yp(val, ph: ph)
            p.move(to: CGPoint(x: leftPad, y: gy))
            p.addLine(to: CGPoint(x: leftPad + pw, y: gy))
        }
        ctx.stroke(p, with: .color(.gray.opacity(0.18)), lineWidth: 0.5)
    }

    private func catmullRomPath(points: [CGPoint]) -> Path {
        guard points.count >= 2 else { return Path() }
        var path = Path()
        path.move(to: points[0])
        let n = points.count
        for i in 0..<(n - 1) {
            let p0 = points[max(0, i - 1)]
            let p1 = points[i]
            let p2 = points[i + 1]
            let p3 = points[min(n - 1, i + 2)]
            let cp1 = CGPoint(
                x: p1.x + (p2.x - p0.x) / 6.0,
                y: p1.y + (p2.y - p0.y) / 6.0
            )
            let cp2 = CGPoint(
                x: p2.x - (p3.x - p1.x) / 6.0,
                y: p2.y - (p3.y - p1.y) / 6.0
            )
            path.addCurve(to: p2, control1: cp1, control2: cp2)
        }
        return path
    }

    private func sampleEdge(_ fn: (Double) -> Double, pw: CGFloat, ph: CGFloat) -> [CGPoint] {
        (0...sampleCount).map { s in
            let t = Double(s) / Double(sampleCount)
            return CGPoint(x: xp(CGFloat(t), pw: pw), y: yp(fn(t), ph: ph))
        }
    }

    private func drawBands(_ ctx: inout GraphicsContext, pw: CGFloat, ph: CGFloat) {
        let topPts    = sampleEdge(upperY,    pw: pw, ph: ph)
        let botPts    = sampleEdge(lowerY,    pw: pw, ph: ph)
        let midHiPts  = sampleEdge(midUpperY, pw: pw, ph: ph)
        let midLoPts  = sampleEdge(midLowerY, pw: pw, ph: ph)

        var outer = catmullRomPath(points: topPts)
        outer.addLine(to: botPts.last!)
        outer.addPath(catmullRomPath(points: botPts.reversed()))
        outer.closeSubpath()

        var inner = catmullRomPath(points: midHiPts)
        inner.addLine(to: midLoPts.last!)
        inner.addPath(catmullRomPath(points: midLoPts.reversed()))
        inner.closeSubpath()

        ctx.fill(outer, with: .color(outerColor))
        ctx.fill(inner, with: .color(innerColor))

        let n  = chartPoints.count
        let t  = Double(activeIndex) / Double(n - 1)
        let ax = xp(CGFloat(t), pw: pw)

        var clipPath = Path()
        clipPath.addRect(CGRect(x: leftPad, y: -10, width: ax - leftPad, height: ph + 20))

        var hCtx = ctx
        hCtx.clip(to: clipPath)
        hCtx.fill(outer, with: .color(outerHighlightColor))
        hCtx.fill(inner, with: .color(innerHighlightColor))
    }

    private func drawRule(_ ctx: inout GraphicsContext, pw: CGFloat, ph: CGFloat) {
        let n = chartPoints.count
        let t = Double(activeIndex) / Double(n - 1)
        let ax  = xp(CGFloat(t), pw: pw)
        let dotY = yp(upperY(at: t), ph: ph)

        var rule = Path()
        rule.move(to: CGPoint(x: ax, y: dotY + 10))
        rule.addLine(to: CGPoint(x: ax, y: ph))
        ctx.stroke(
            rule,
            with: .color(dotColor.opacity(0.65)),
            style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
        )

        let r: CGFloat = 6
        ctx.fill(
            Path(ellipseIn: CGRect(x: ax - r, y: dotY - r, width: r * 2, height: r * 2)),
            with: .color(dotColor)
        )
    }

    private func yAxisOverlay(ph: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(yLabels, id: \.0) { val, label in
                Text(label)
                    .font(.dmSansAxis)
                    .foregroundColor(.textSecondary)
                    .offset(x: 0, y: yp(val, ph: ph) - 7)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func xAxisOverlay(pw: CGFloat, ph: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(Array(chartPoints.enumerated()), id: \.offset) { i, pt in
                let t = CGFloat(i) / CGFloat(chartPoints.count - 1)
                Text(pt.month)
                    .font(.dmSansAxis)
                    .fontWeight(i == activeIndex ? .semibold : .regular)
                    .foregroundColor(i == activeIndex ? .textPrimary : .textSecondary)
                    .offset(x: xp(t, pw: pw) - 10, y: ph + 5)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func tooltipOverlay(pw: CGFloat, ph: CGFloat) -> some View {
        let n = chartPoints.count
        let t = CGFloat(activeIndex) / CGFloat(n - 1)
        let ax = xp(t, pw: pw)
        let status = chartPoints[min(activeIndex, n - 1)].status

        return VStack(spacing: 0) {
            Text(status)
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
        .offset(x: ax - 45, y: -20)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.closeSubpath()
        return p
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
