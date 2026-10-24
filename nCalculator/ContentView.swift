
import SwiftUI
// loading screen UI pretty straight forward
struct SplashView: View {
     let nyx1 = Color(hex: 0xFFD479)
     let nyx2 = Color(hex: 0x73FDFF)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [nyx1, nyx2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 10) {
                Image("NCalLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                Text("nCalculator")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding()
        }
    }
}
// color extension
extension Color {
    // Light mode
    static let nyxYellow = Color(hex: 0xFFD479)
    static let nyxCyan   = Color(hex: 0x73FDFF)

    // Dark mode
    static let nyxYellowDark = Color(hex: 0x4A3708)
    static let nyxCyanDark   = Color(hex: 0x0A3F42)

    init(hex: UInt, opacity: Double = 1) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}
#Preview {
    SplashView()
}
// logic for loading screen
struct ContentView: View {
    @State var showSplash = true
    var body: some View {
        ZStack{
            if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                CalculatorView()
                    .transition(.opacity)
            }
        } .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeInOut(duration: 0.5)) {
                showSplash = false
            }
        }
    }
}
