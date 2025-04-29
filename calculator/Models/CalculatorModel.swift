import Foundation
import Combine
import SwiftUI

class CalculatorModel: ObservableObject {
    @Published var display: String = "0"
    private var currentValue: Double = 0
    private var storedValue: Double? = nil
    private var currentOperation: Operation? = nil
    private var isTyping: Bool = false

    enum Operation {
        case add, subtract, multiply, divide
        case sin, cos, tan, log, sqrt, power
    }
    
    func receiveInput(_ input: CalculatorButton) {
        switch input {
        case .digit(let n): appendDigit(n)
        case .decimal: appendDecimal()
        case .operation(let op): handleOperation(op)
        case .equals: calculate()
        case .clear: reset()
        case .toggleSign: toggleSign()
        case .percentage: applyPercentage()    // Yeni eklenen satır
        }
    }
    
    private func appendDigit(_ n: Int) {
        if isTyping {
            if display == "0" { display = String(n) }
            else { display += String(n) }
        } else {
            display = String(n)
            isTyping = true
        }
        currentValue = Double(display) ?? 0
    }
    
    private func appendDecimal() {
        if !display.contains(".") {
            display += "."
            isTyping = true
        }
    }
    
    private func handleOperation(_ op: Operation) {
        switch op {
        case .sin: applyTrig(sin)
        case .cos: applyTrig(cos)
        case .tan: applyTrig(tan)
        case .log: applyUnary(log10)
        case .sqrt: applyUnary(sqrt)
        case .power:
            prepareForBinary(op)
        default:
            prepareForBinary(op)
        }
    }
    
    private func applyUnary(_ fn: (Double) -> Double) {
        currentValue = fn(currentValue)
        display = formatted(currentValue)
        isTyping = false
    }
    
    private func applyTrig(_ fn: (Double) -> Double) {
        let radians = currentValue * .pi / 180
        currentValue = fn(radians)
        display = formatted(currentValue)
        isTyping = false
    }
    
    private func prepareForBinary(_ op: Operation) {
        if isTyping { calculate() }
        currentOperation = op
        storedValue = currentValue
        isTyping = false
    }
    
    private func calculate() {
        guard let op = currentOperation, let stored = storedValue else { return }
        switch op {
        case .add:
            currentValue = stored + currentValue
        case .subtract:
            currentValue = stored - currentValue
        case .multiply:
            currentValue = stored * currentValue
        case .divide:
            currentValue = currentValue != 0 ? stored / currentValue : 0
        case .power:
            currentValue = pow(stored, currentValue)
        default:
            break
        }
        display = formatted(currentValue)
        storedValue = nil
        currentOperation = nil
        isTyping = false
    }
    
    private func reset() {
        display = "0"
        currentValue = 0
        storedValue = nil
        currentOperation = nil
        isTyping = false
    }
    
    private func toggleSign() {
        if isTyping {
            if display.first == "-" {
                display.removeFirst()
            } else if display != "0" {
                display = "-" + display
            }
        } else {
            currentValue = -currentValue
            display = formatted(currentValue)
        }
        isTyping = true
    }
    
    // Yeni eklenen fonksiyon: Yüzde hesaplama (mevcut değeri yüzdeye çevirir)
    private func applyPercentage() {
        currentValue = currentValue / 100
        display = formatted(currentValue)
        isTyping = false
    }
    
    private func formatted(_ v: Double) -> String {
        return v.truncatingRemainder(dividingBy: 1) == 0 ?
            String(Int(v)) : String(format: "%g", v)
    }
}
