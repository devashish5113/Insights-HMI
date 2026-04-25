

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
                .frame(width: 50, alignment: .leading)

            
            HStack(spacing: cellSpacing) {
                ForEach(0..<row.totalCells, id: \.self) { idx in
                    RoundedRectangle(cornerRadius: cellRadius)
                        .fill(
                            idx < row.filledCells
                                ? AnyShapeStyle(cellGradient(for: row.color))
                                : AnyShapeStyle(Color.heatmapEmpty)
                        )
                        .frame(width: cellWidth, height: cellHeight)
                }
            }
        }
    }

    

    private func cellGradient(for token: String) -> LinearGradient {
        switch token {
        case "lavender":
            return LinearGradient(
                stops: [
                    .init(color: Color(red: 180/255, green: 168/255, blue: 218/255),          location: 0.00),
                    .init(color: Color(red: 180/255, green: 168/255, blue: 218/255, opacity: 0.34), location: 0.95)
                ],
                startPoint: .leading, endPoint: .trailing
            )
        case "salmon":
            return LinearGradient(
                stops: [
                    .init(color: Color(red: 233/255, green: 149/255, blue: 151/255),          location: 0.005),
                    .init(color: Color(red: 233/255, green: 149/255, blue: 151/255, opacity: 0.56), location: 0.993)
                ],
                startPoint: .leading, endPoint: .trailing
            )
        case "sage":
            return LinearGradient(
                stops: [
                    .init(color: Color(red: 110/255, green: 140/255, blue: 130/255),          location: 0.00),
                    .init(color: Color(red: 110/255, green: 140/255, blue: 130/255, opacity: 0.38), location: 0.95)
                ],
                startPoint: .leading, endPoint: .trailing
            )
        case "pink":
            return LinearGradient(
                stops: [
                    .init(color: Color(red: 245/255, green: 195/255, blue: 196/255),          location: 0.00),
                    .init(color: Color(red: 245/255, green: 195/255, blue: 196/255, opacity: 0.52), location: 1.00)
                ],
                startPoint: .leading, endPoint: .trailing
            )
        default:
            return LinearGradient(
                colors: [Color.lavenderSoft.opacity(0.7), Color.lavenderSoft],
                startPoint: .leading, endPoint: .trailing
            )
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
