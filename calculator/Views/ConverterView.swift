import SwiftUI

struct ConverterView: View {
    @State private var input = ""
    @State private var category = "Length"
    @State private var fromUnit = "Meter"
    @State private var toUnit = "Kilometer"
    
    let categories = ["Length", "Weight", "Temperature"]
    let lengthUnits = ["Meter", "Kilometer", "Centimeter"]
    let weightUnits = ["Gram", "Kilogram", "Pound"]
    let tempUnits = ["Celsius", "Fahrenheit"]
    
    var units: [String] {
        switch category {
        case "Length": return lengthUnits
        case "Weight": return weightUnits
        default: return tempUnits
        }
    }
    
    var result: String {
        guard let value = Double(input) else { return "?" }
        switch category {
        case "Length": return String(format: "%g", convertLength(value))
        case "Weight": return String(format: "%g", convertWeight(value))
        default: return String(format: "%g", convertTemp(value))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Modern tasarımlı kart kapsayıcı
                VStack(spacing: 16) {
                    // Kategori seçim kontrolü
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { txt in
                            Text(txt).tag(txt)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    // Değer girişi
                    TextField("Enter value", text: $input)
                        .padding()
                        .keyboardType(.decimalPad)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 2, y: 2)
                        .padding(.horizontal)
                    
                    // Birim seçimi (From & To)
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("From")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("From", selection: $fromUnit) {
                                ForEach(units, id: \.self) { txt in
                                    Text(txt).tag(txt)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                        Spacer()
                        VStack(alignment: .leading, spacing: 8) {
                            Text("To")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Picker("To", selection: $toUnit) {
                                ForEach(units, id: \.self) { txt in
                                    Text(txt).tag(txt)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    // Sonuç ekranı
                    VStack(spacing: 8) {
                        Text("Result")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text(result)
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.30, green: 0.20, blue: 0.15))
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 2, y: 2)
                    )
                    .padding(.horizontal)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.98, green: 0.95, blue: 0.90))
                        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
                )
                .padding()
            }
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
        .onChange(of: category, perform: { _ in
            // Kategori değişince birim değerlerini sıfırla
            fromUnit = units.first ?? ""
            toUnit = units.count > 1 ? units[1] : units.first ?? ""
        })
    }
    
    // Dönüşüm fonksiyonları
    func convertLength(_ v: Double) -> Double {
        let meters = v * (fromUnit == "Kilometer" ? 1000 : (fromUnit == "Centimeter" ? 0.01 : 1))
        return meters / (toUnit == "Kilometer" ? 1000 : (toUnit == "Centimeter" ? 0.01 : 1))
    }
    func convertWeight(_ v: Double) -> Double {
        let grams = v * (fromUnit == "Kilogram" ? 1000 : (fromUnit == "Pound" ? 453.592 : 1))
        return grams / (toUnit == "Kilogram" ? 1000 : (toUnit == "Pound" ? 453.592 : 1))
    }
    func convertTemp(_ v: Double) -> Double {
        if fromUnit == "Celsius" {
            let c = v
            let f = c * 9/5 + 32
            return toUnit == "Celsius" ? c : f
        } else {
            let f = v
            let c = (f - 32) * 5/9
            return toUnit == "Celsius" ? c : f
        }
    }
}
