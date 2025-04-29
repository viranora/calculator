import SwiftUI

enum AppMode: String, CaseIterable, Identifiable {
    case calculator = "Calculator"
    case converter  = "Convert"
    var id: String { rawValue }
}

struct ContentView: View {
    @State private var selectedMode: AppMode = .calculator

    var body: some View {
        VStack(spacing: 0) {
            // Sadece Calculator ve Converter modları
            Picker("Mode", selection: $selectedMode) {
                ForEach(AppMode.allCases, id: \.self) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 24)
            .padding(.vertical, 12)

            Divider()

            Group {
                switch selectedMode {
                case .calculator:
                    StandardCalculatorView()
                case .converter:
                    ConverterView()
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            Spacer()
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.90),
                    Color(red: 0.93, green: 0.76, blue: 0.80)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

#Preview {
    ContentView()
}
