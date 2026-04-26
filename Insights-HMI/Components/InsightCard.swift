import SwiftUI

struct InsightCard<Content: View>: View {

    
    let content: () -> Content

    var body: some View {
        content()
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.cardWhite)
                    .shadow(color: Color(red: 13/255, green: 10/255, blue: 44/255).opacity(0.08), radius: 2.02, x: 0, y: 1.35)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            .padding(.horizontal, 16)
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.dmSansSectionHead)
            .tracking(-20 * 0.02) 
            .lineSpacing(0)
            .foregroundColor(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
    }
}

#Preview {
    VStack(spacing: 16) {
        SectionHeader(title: "Stability Summary")
        InsightCard {
            Text("Card content goes here")
                .font(.dmSansBody)
                .foregroundColor(.textSecondary)
        }
    }
    .padding(.vertical)
    .background(Color.backgroundMint)
}
