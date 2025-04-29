import SwiftUI

enum CalculatorButton: Hashable {
    case digit(Int), decimal, operation(CalculatorModel.Operation), equals, clear, toggleSign, percentage  // Yeni case: percentage
    
    var title: String {
        switch self {
        case .digit(let n): return String(n)
        case .decimal: return "."
        case .operation(let op): return op.symbol
        case .equals: return "="
        case .clear: return "AC"
        case .toggleSign: return "±"
        case .percentage: return "%"    // Yeni başlık
        }
    }
    
    var background: LinearGradient {
        switch self {
        case .operation:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.90, green: 0.70, blue: 0.75),
                                            Color(red: 0.95, green: 0.80, blue: 0.85)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .equals:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.60, green: 0.45, blue: 0.40),
                                            Color(red: 0.45, green: 0.30, blue: 0.25)]),
                startPoint: .top,
                endPoint: .bottom
            )
        case .clear, .toggleSign, .percentage:   // .percentage belirlenen grupta
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.98, green: 0.85, blue: 0.88),
                                            Color(red: 0.94, green: 0.70, blue: 0.75)]),
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.98, green: 0.95, blue: 0.90),
                                            Color(red: 0.93, green: 0.90, blue: 0.85)]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var foreground: Color {
        switch self {
        case .operation, .equals, .clear, .toggleSign, .percentage:
            return .white
        default:
            return Color(red: 0.30, green: 0.20, blue: 0.15)
        }
    }
    
    var shadowColor: Color { Color.black.opacity(0.15) }
}

extension CalculatorModel.Operation {
    var symbol: String {
        switch self {
        case .add: return "+"
        case .subtract: return "−"
        case .multiply: return "×"
        case .divide: return "÷"
        case .sin: return "sin"
        case .cos: return "cos"
        case .tan: return "tan"
        case .log: return "log"
        case .sqrt: return "√"
        case .power: return "^"
        }
    }
}
