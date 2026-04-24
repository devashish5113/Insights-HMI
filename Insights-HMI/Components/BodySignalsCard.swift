

import SwiftUI

struct BodySignalsCard: View {

    let slices: [SymptomSlice]

    
    private let ringDiameter: CGFloat = 240
    
    private let lineWidth: CGFloat = 44

    
    private let sliceColors: [Color] = [
        Color.lavenderSoft,                  
        Color.salmonPink,                    
        Color.sagePrimary,                   
        Color(red: 244/255, green: 195/255, blue: 196/255)  
    ]

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
                let start = slice.startAngle / 360.0
                let end   = slice.endAngle   / 360.0
                let color = idx < sliceColors.count ? sliceColors[idx] : .gray

                Circle()
                    .trim(from: start, to: end)
                    .stroke(
                        
                        LinearGradient(
                            colors: [color, color.opacity(0.65)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                    )
                    
                    .rotationEffect(.degrees(-90))
                    .frame(width: ringDiameter, height: ringDiameter)
            }
        }
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
