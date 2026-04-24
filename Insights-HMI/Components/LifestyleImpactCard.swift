

import SwiftUI

struct LifestyleImpactCard: View {

    let rows: [LifestyleRow]
    @Binding var selectedPeriod: String

    
    private let cellWidth:  CGFloat = 28
    private let cellHeight: CGFloat = 22
    private let cellRadius: CGFloat = 4
    private let cellSpacing: CGFloat = 4

    var body: some View {
        InsightCard {
            VStack(alignment: .leading, spacing: 16) {

                
                HStack {
                    Text("Correlation Strength")
                        .font(.dmSansCardSub)
                        .tracking(-16 * 0.02)
                        .lineSpacing(0)
                        .foregroundColor(.textPrimary)

                    Spacer()

                    
                    Menu {
                        Button("4 months") { selectedPeriod = "4 months" }
                        Button("6 months") { selectedPeriod = "6 months" }
                        Button("1 year") { selectedPeriod = "1 year" }
                    } label: {
                        HStack(spacing: 4) {
                            Text(selectedPeriod)
                                .font(.dmSansAxis)
                                .foregroundColor(.textSecondary)
                            Image(systemName: "chevron.down")
                                .font(.system(size: 8, weight: .medium))
                                .foregroundColor(.textSecondary)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.pillBackground)
                        )
                    }
                }

                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(rows) { row in
                        heatmapRow(row)
                    }
                }
            }
        }
    }

    

    @ViewBuilder
    private func heatmapRow(_ row: LifestyleRow) -> some View {
        HStack(spacing: 6) {
            
            Text(row.label)
                .font(.dmSansAxis)
                .foregroundColor(.textPrimary)
                .frame(width: 38, alignment: .leading)

            
            HStack(spacing: cellSpacing) {
                ForEach(0..<row.totalCells, id: \.self) { idx in
                    RoundedRectangle(cornerRadius: cellRadius)
                        .fill(idx < row.filledCells ? cellColor(for: row.color) : Color.heatmapEmpty)
                        .frame(width: cellWidth, height: cellHeight)
                }
            }
        }
    }

    

    private func cellColor(for token: String) -> Color {
        switch token {
        case "lavender": return Color.lavenderSoft
        case "salmon":   return Color.salmonPink
        case "sage":     return Color.sagePrimary
        default:         return Color.lavenderSoft
        }
    }
}

#Preview {
    LifestyleImpactCardPreview()
}

struct LifestyleImpactCardPreview: View {
    @State private var period = "4 months"
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Lifestyle Impact")
                LifestyleImpactCard(rows: .sample, selectedPeriod: $period)
            }
            .padding(.vertical)
        }
        .background(Color.backgroundMint)
    }
}
