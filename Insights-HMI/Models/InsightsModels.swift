

import Foundation

struct StabilityData {
    let score: Int
    let subtitle: String
    let chartPoints: [CyclePoint]
    let bandPoints: [StabilityBandPoint]
    let activeMonthIndex: Int
    let tooltip: String
}

struct CyclePoint: Identifiable {
    let id = UUID()
    let month: String
    let value: Double
    let status: String
}

struct StabilityBandPoint: Identifiable {
    let id = UUID()
    let month: String
    let upper: Double
    let mid: Double
    let lower: Double
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
            CyclePoint(month: "Jan", value: 24, status: "Stability\nStable"),
            CyclePoint(month: "Feb", value: 26, status: "Stability\nImproving"),
            CyclePoint(month: "Mar", value: 30, status: "Stability\nImproving"),
            CyclePoint(month: "Apr", value: 28, status: "Stability\nStable")
        ],
        bandPoints: [
            StabilityBandPoint(month: "Jan", upper: 24.5, mid: 24.2, lower: 24.0),
            StabilityBandPoint(month: "Feb", upper: 27.0, mid: 25.8, lower: 24.5),
            StabilityBandPoint(month: "Mar", upper: 30.5, mid: 28.0, lower: 25.5),
            StabilityBandPoint(month: "Apr", upper: 33.0, mid: 30.0, lower: 27.0)
        ],
        activeMonthIndex: 2,
        tooltip: "Stability\nImproving"
    )
}

extension CycleTrendsData {
    static let sample = CycleTrendsData(bars: [
        CycleBar(month: "Jan", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2),
        CycleBar(month: "Feb", totalDays: 30, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2),
        CycleBar(month: "Mar", totalDays: 32, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2),
        CycleBar(month: "Apr", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2),
        CycleBar(month: "May", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2),
        CycleBar(month: "Jun", totalDays: 28, lavenderFraction: 0.6, greenFraction: 0.2, pinkFraction: 0.2)
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
            ("Mood",     30),
            ("Bloating", 31),
            ("Acne",     17),
            ("Fatigue",  21)
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
        LifestyleRow(label: "Exercise", filledCells: 4, totalCells: 9, color: "salmon")
    ]
}
