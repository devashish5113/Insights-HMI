

import SwiftUI

struct BodySignalsCard: View {

    let slices: [SymptomSlice]

    @State private var tappedIndex: Int? = nil

    private let ringDiameter: CGFloat = 240
    private let lineWidth: CGFloat    = 44
    private let popDistance: CGFloat  = 7


    var body: some View {
        InsightCard {
            VStack(alignment: .leading, spacing: 16) {

                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Symptom Trends")
                        .font(.dmSansSectionHead)
                        .foregroundColor(.textPrimary)

                    Text("Compared to last cycle")
                        .font(.dmSansBody)
                        .foregroundColor(.textSecondary)
                }

                
                ZStack {
                    donutRing
                    floatingLabels
                }
                .frame(height: ringDiameter + 60) 
                .frame(maxWidth: .infinity)
            }
        }
    }

    

    private var donutRing: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: ringDiameter - lineWidth * 2)

            ForEach(Array(slices.enumerated()), id: \.offset) { idx, slice in
                let start      = slice.startAngle / 360.0
                let end        = slice.endAngle   / 360.0
                let isPopped   = tappedIndex == idx

                // Radial direction for this segment
                let midDeg     = (slice.startAngle + slice.endAngle) / 2.0 - 90.0
                let midRad     = midDeg * Double.pi / 180.0
                let dx: CGFloat = isPopped ? CGFloat(cos(midRad)) * popDistance : 0
                let dy: CGFloat = isPopped ? CGFloat(sin(midRad)) * popDistance : 0

                Circle()
                    .trim(from: start, to: end)
                    .stroke(
                        ringAngularGradient,
                        style: StrokeStyle(
                            lineWidth: isPopped ? lineWidth + 4 : lineWidth,
                            lineCap: .butt
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .frame(width: ringDiameter, height: ringDiameter)
                    .offset(x: dx, y: dy)
                    .shadow(color: isPopped ? .black.opacity(0.12) : .clear, radius: 6, x: dx * 0.4, y: dy * 0.4)
                    .animation(.spring(response: 0.28, dampingFraction: 0.62), value: tappedIndex)
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    let center = CGPoint(x: ringDiameter / 2, y: ringDiameter / 2)
                    let dx     = value.location.x - center.x
                    let dy     = value.location.y - center.y
                    let dist   = sqrt(dx * dx + dy * dy)

                    let innerR = (ringDiameter / 2) - lineWidth - 16
                    let outerR = ringDiameter / 2 + 16
                    guard dist >= innerR && dist <= outerR else { return }

                    var angle = atan2(dy, dx) * 180 / .pi + 90
                    if angle < 0 { angle += 360 }
                    let fraction = angle / 360.0

                    let total = slices.reduce(0) { $0 + $1.percentage }
                    var cumulative = 0.0
                    for (i, slice) in slices.enumerated() {
                        cumulative += slice.percentage / total
                        if fraction <= cumulative {
                            if tappedIndex != i {
                                withAnimation(.spring(response: 0.28, dampingFraction: 0.62)) {
                                    tappedIndex = i
                                }
                            }
                            return
                        }
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.62)) {
                        tappedIndex = nil
                    }
                }
        )
    }

    

    
    
    private var floatingLabels: some View {
        GeometryReader { geo in
            let cx = geo.size.width  / 2
            let cy = geo.size.height / 2
            
            let r: CGFloat = ringDiameter / 2 + 20

            ForEach(Array(slices.enumerated()), id: \.offset) { idx, slice in
                
                let midDeg = (slice.startAngle + slice.endAngle) / 2 - 90
                let midRad = midDeg * Double.pi / 180

                let lx = cx + CGFloat(cos(midRad)) * r
                let ly = cy + CGFloat(sin(midRad)) * r

                bubbleLabel(pct: Int(slice.percentage), label: slice.label)
                    .position(x: lx, y: ly)
            }
        }
    }

    

    @ViewBuilder
    private func bubbleLabel(pct: Int, label: String) -> some View {
        VStack(spacing: 1) {
            Text("\(pct)%")
                .font(.custom("DMSans-SemiBold", size: 13))
                .foregroundColor(.textPrimary)
            Text(label)
                .font(.custom("DMSans-Regular", size: 11))
                .foregroundColor(.textPrimary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Circle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                .frame(width: 60, height: 60)
        )
        .frame(width: 60, height: 60)
    }

    // Single angular gradient shared by all arc trims.
    // Each segment's colours occupy its cumulative fraction band.
    // Duplicate stops at boundaries create hard colour switches between segments.
    // After .rotationEffect(-90°), location 0.0 aligns with 12-o'clock / arc start.
    private var ringAngularGradient: AngularGradient {
        AngularGradient(
            stops: [
                // Bloating  0.000 → 0.313  (medium lavender → soft lavender)
                .init(color: Color(red: 165/255, green: 153/255, blue: 208/255), location: 0.000),
                .init(color: Color(red: 212/255, green: 207/255, blue: 235/255), location: 0.313),
                // Fatigue   0.313 → 0.525  (soft salmon → light blush)
                .init(color: Color(red: 218/255, green: 125/255, blue: 127/255), location: 0.313),
                .init(color: Color(red: 240/255, green: 195/255, blue: 196/255), location: 0.525),
                // Acne      0.525 → 0.697  (light mint → soft sage)
                .init(color: Color(red: 95/255, green: 128/255, blue: 118/255), location: 0.525),
                .init(color: Color(red: 190/255, green: 230/255, blue: 218/255), location: 0.697),
                // Mood      0.697 → 1.000  (soft rose → muted rose)
                .init(color: Color(red: 226/255, green: 162/255, blue: 164/255), location: 0.697),
                .init(color: Color(red: 238/255, green: 195/255, blue: 196/255), location: 1.000)
            ],
            center: .center,
            startAngle: .degrees(0),
            endAngle:   .degrees(360)
        )
    }
}

#Preview {
    ScrollView {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Body Signals")
            BodySignalsCard(slices: .sample)
        }
        .padding(.vertical)
    }
    .background(Color.backgroundMint)
}
