import Foundation

struct StabilityData {
    let score: Int
    let subtitle: String
    let chartPoints: [CyclePoint]
    let activeMonthIndex: Int
    let tooltip: String
}

struct CyclePoint: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
    let status: String
}


struct CycleTrendsData {
    let bars: [CycleBar]
}

struct CycleBar: Identifiable {
    let id = UUID()
    let month: String
    let totalDays: Int
    let lavenderFraction: Double
    let greenFraction: Double
    let pinkFraction: Double
    let greenTopOffset: Double
    let pinkBottomOffset: Double
}

struct WeightData {
    let points: [WeightPoint]
}

struct WeightPoint: Identifiable {
    let id = UUID()
    let month: String
    let kg: Double
}

struct SymptomSlice: Identifiable {
    let id = UUID()
    let label: String
    let percentage: Double             
    let startAngle: Double             
    let endAngle: Double
}

struct LifestyleRow: Identifiable {
    let id = UUID()
    let label: String
    let filledCells: Int               
    let totalCells: Int
    let color: String                  
}

extension StabilityData {
    static let sample = StabilityData(
        score: 78,
        subtitle: "Based on your recent logs and symptom\npatterns.",
        chartPoints: [
            CyclePoint(month: "Jan", value: 24.0, status: "Stability\nStable"),
            CyclePoint(month: "Feb", value: 24.8, status: "Stability\nImproving"),
            CyclePoint(month: "Mar", value: 27.2, status: "Stability\nImproving"),
            CyclePoint(month: "Apr", value: 32.0, status: "Stability\nPeak")
        ],
        activeMonthIndex: 2,
        tooltip: "Stability\nImproving"
    )
}

extension CycleTrendsData {
    static let sample = CycleTrendsData(bars: [
        CycleBar(month: "Jan", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.38, pinkBottomOffset: 0.00),
        CycleBar(month: "Feb", totalDays: 30, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.12, pinkBottomOffset: 0.09),
        CycleBar(month: "Mar", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.22, pinkBottomOffset: 0.13),
        CycleBar(month: "Apr", totalDays: 32, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.14, pinkBottomOffset: 0.10),
        CycleBar(month: "May", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.20, pinkBottomOffset: 0.07),
        CycleBar(month: "Jun", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.30, pinkBottomOffset: 0.00),
        CycleBar(month: "Jul", totalDays: 29, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.35, pinkBottomOffset: 0.00),
        CycleBar(month: "Aug", totalDays: 31, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.16, pinkBottomOffset: 0.11),
        CycleBar(month: "Sep", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.25, pinkBottomOffset: 0.08),
        CycleBar(month: "Oct", totalDays: 30, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.18, pinkBottomOffset: 0.12),
        CycleBar(month: "Nov", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.28, pinkBottomOffset: 0.06),
        CycleBar(month: "Dec", totalDays: 27, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2, greenTopOffset: 0.32, pinkBottomOffset: 0.00)
    ])
}

extension WeightData {
    static let monthlySample = WeightData(points: [
        WeightPoint(month: "Jan", kg: 42),
        WeightPoint(month: "Feb", kg: 44),
        WeightPoint(month: "Mar", kg: 52),
        WeightPoint(month: "Apr", kg: 58),
        WeightPoint(month: "May", kg: 51)
    ])

    static let weeklySample = WeightData(points: [
        WeightPoint(month: "Apr 1-7",   kg: 51),
        WeightPoint(month: "Apr 8-14",  kg: 53),
        WeightPoint(month: "Apr 15-21", kg: 50),
        WeightPoint(month: "Apr 22-28", kg: 52)
    ])
}

extension Array where Element == SymptomSlice {
    static let sample: [SymptomSlice] = {
        
        let data: [(String, Double)] = [
            ("Bloating", 31),
            ("Fatigue",  21),
            ("Acne",     17),
            ("Mood",     30)
        ]
        let total = data.reduce(0) { $0 + $1.1 }
        var start = 0.0
        return data.map { label, pct in
            let span = (pct / total) * 360
            let slice = SymptomSlice(label: label, percentage: pct, startAngle: start, endAngle: start + span)
            start += span
            return slice
        }
    }()
}

extension Array where Element == LifestyleRow {
    static let sample: [LifestyleRow] = [
        LifestyleRow(label: "Sleep",    filledCells: 7, totalCells: 9, color: "lavender"),
        LifestyleRow(label: "Hydrate",  filledCells: 3, totalCells: 9, color: "salmon"),
        LifestyleRow(label: "Caffeine", filledCells: 5, totalCells: 9, color: "sage"),
        LifestyleRow(label: "Exercise", filledCells: 4, totalCells: 9, color: "pink")
    ]
}
