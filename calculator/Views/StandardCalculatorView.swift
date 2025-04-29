import SwiftUI

struct StandardCalculatorView: View {
    @ObservedObject private var model = CalculatorModel()
    @State private var showAdvanced = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
    
    // Güncellenmiş standart düzen:
    // Row 1: [AC, ±, %, ÷]
    // Diğer satırlar aynı kalıyor.
    private var standardButtons: [CalculatorButton?] {
        return [
            .clear, .toggleSign, .percentage, .operation(.divide),
            .digit(7), .digit(8), .digit(9), .operation(.multiply),
            .digit(4), .digit(5), .digit(6), .operation(.subtract),
            .digit(1), .digit(2), .digit(3), .operation(.add),
            .digit(0), .decimal, .equals, nil  // Son hücre gelişmiş mod geçiş tuşu için
        ]
    }
    
    private let advancedLayout: [CalculatorButton?] = [
        .operation(.sin), .operation(.cos), .operation(.tan), .operation(.power),
        .operation(.log), .operation(.sqrt), nil, nil
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            Text(model.display)
                .font(.system(size: 64, weight: .black, design: .rounded))
                .foregroundColor(Color(red: 0.30, green: 0.20, blue: 0.15))
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 12)
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(standardButtons.indices, id: \.self) { idx in
                    if let btn = standardButtons[idx] {
                        Button(action: { model.receiveInput(btn) }) {
                            Text(btn.title)
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .frame(width: buttonSize(), height: buttonSize())
                                .background(btn.background)
                                .foregroundColor(btn.foreground)
                                .cornerRadius(buttonSize() / 2)
                                .shadow(color: btn.shadowColor, radius: 6, x: 3, y: 3)
                        }
                    } else {
                        if idx == 19 {
                            Button(action: { withAnimation { showAdvanced.toggle() } }) {
                                Image(systemName: showAdvanced ? "chevron.down.circle.fill" : "chevron.up.circle.fill")
                                    .font(.system(size: 28))
                                    .frame(width: buttonSize(), height: buttonSize())
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.pink.opacity(0.7), Color.pink]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(buttonSize() / 2)
                                    .shadow(color: Color.black.opacity(0.15), radius: 6, x: 3, y: 3)
                            }
                        } else {
                            Color.clear.frame(width: buttonSize(), height: buttonSize())
                        }
                    }
                }
            }
            
            if showAdvanced {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(advancedLayout.indices, id: \.self) { idx in
                        if let btn = advancedLayout[idx] {
                            Button(action: { model.receiveInput(btn) }) {
                                Text(btn.title)
                                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .frame(width: buttonSize(), height: buttonSize())
                                    .background(btn.background)
                                    .foregroundColor(btn.foreground)
                                    .cornerRadius(buttonSize() / 2)
                                    .shadow(color: btn.shadowColor, radius: 4, x: 2, y: 2)
                            }
                        } else {
                            Color.clear.frame(width: buttonSize(), height: buttonSize())
                        }
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func buttonSize() -> CGFloat {
        let total = UIScreen.main.bounds.width - 2 * 24 - (3 * 20)
        return total / 4
    }
}
