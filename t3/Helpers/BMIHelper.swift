import Foundation

enum BMIHelper {
    static func value(weight: Double, height: Double) -> Double {
        weight / max(height * height, 0.01)
    }

    static func classification(for bmi: Double) -> String {
        switch bmi {
        case ..<18.5: return "Bajo peso"
        case 18.5..<25: return "Peso normal"
        case 25..<30: return "Sobrepeso"
        default: return "Obesidad"
        }
    }
}
