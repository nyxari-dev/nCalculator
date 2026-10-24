import SwiftUI
// button array
struct CalculatorView: View {
    let rows: [[String]] = [
        ["C", "÷", "="],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "−"],
        ["1", "2", "3", "+"]
    ]
    // equation variables
    @State var display: String = "0"
    @State var firstNum: Double? = nil
    @State var pendingOperator = ""
    @State var startNewNum: Bool = false

    @Environment(\.colorScheme) private var colorScheme
    // body of the app including the app background and button layout
    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            } else {
                LinearGradient(
                    colors: [.nyxYellow, .nyxCyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            }

            VStack(spacing: 12) {
                HStack(spacing: 10) {
                    if colorScheme == .light {
                        Image("NCalLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }

                    Text("nCalculator")
                        .font(.title3)
                        .bold()
                        .foregroundStyle(.primary)
                }
                .padding(.top)

                Spacer()

                Text(display)
                    .font(.system(size: 72, weight: .light))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal)
// grid layout, iterates through the array and builds buttons for each item
                Grid(horizontalSpacing: 12, verticalSpacing: 12) {
                    ForEach(rows, id: \.self) { row in
                        GridRow {
                            ForEach(row, id: \.self) { symbol in
                                CalcButton(title: symbol) {
                                    buttonTapped(symbol)
                                }
                            }
                        }
                    }

                    GridRow {
                        CalcButton(title: "0") {
                            buttonTapped("0")
                        }
                        .gridCellColumns(2)
                    }
                }
                .padding()
            }
        }
    }

    // MARK: - Logic
// logic for button pressing
    func buttonTapped(_ symbol: String) {
        switch symbol {
            //logic for the numeratic buttons
        case "0"..."9":
            if startNewNum {
                display = symbol
                startNewNum = false
            } else {
                display = (display == "0") ? symbol : display + symbol
            }
        // clear button logic
        case "C":
            display = "0"
            firstNum = nil
            pendingOperator = ""
            startNewNum = false

        // logic for the equal button with safeguards
        case "=":
            if let first = firstNum, pendingOperator != "" {
                let second = Double(display) ?? 0

                if let result = calculate(first, second, pendingOperator) {
                    display = format(result)
                    firstNum = nil
                    pendingOperator = ""
                    startNewNum = true
                } else {
                    showError()
                }
            }
        // operation button logic
        case "+", "−", "×", "÷":
            if let first = firstNum, pendingOperator != "", !startNewNum {
                let second = Double(display) ?? 0

                if let result = calculate(first, second, pendingOperator) {
                    display = format(result)
                    firstNum = result
                } else {
                    showError()
                    return
                }
            } else {
                firstNum = Double(display)
            }
            pendingOperator = symbol
            startNewNum = true

        default:
            break
        }
    }

    // Returns nil when the calculation is impossible
    func calculate(_ a: Double, _ b: Double, _ op: String) -> Double? {
        switch op {
        case "+": return a + b
        case "−": return a - b
        case "×": return a * b
        case "÷": return b == 0 ? nil : a / b
        default: return nil
        }
    }

    func format(_ number: Double) -> String {
        if number.isFinite && number == number.rounded() && abs(number) < 1e15 {
            return String(Int(number))
        }
        return String(number)
    }
   // error message
    func showError() {
        display = "Error"
        firstNum = nil
        pendingOperator = ""
        startNewNum = true
        Task {
            try? await Task.sleep(for: .seconds(1))
            display = "0"
        }
    }
}

// MARK: - Button Design
// Button design that includes the liquid glass feel for supported systems
struct CalcButton: View {
    let title: String
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            label
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var label: some View {
        let text = Text(title)
            .font(.title)
            .frame(maxWidth: .infinity, minHeight: 80)
            .foregroundStyle(.primary)

        if #available(iOS 26.0, *) {
            text.glassEffect(.regular.interactive(), in: .rect(cornerRadius: 40))
        } else {
            text
                .background(colorScheme == .dark ? Color.nyxCyanDark : Color.nyxCyan)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
}

#Preview {
    CalculatorView()
}
