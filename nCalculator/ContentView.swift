
import SwiftUI

// loading screen UI.. pretty straight forward
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

// which screen is showing
enum Screen {
    case splash
    case whatsNew
    case calculator
}

// logic for loading screen -> update screen -> calculator
struct ContentView: View {
    @State private var screen: Screen = .splash
    @AppStorage("lastSeenVersion") private var lastSeenVersion = ""

    private var currentVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ZStack {
            switch screen {
            case .splash:
                SplashView()
                    .transition(.opacity)

            case .whatsNew:
                UpdateView {
                    lastSeenVersion = currentVersion
                    withAnimation(.easeInOut(duration: 0.5)) {
                        screen = .calculator
                    }
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))

            case .calculator:
                CalculatorView()
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeInOut(duration: 0.6)) {
                // new version? show the update screen, otherwise go straight to the calculator
                screen = (lastSeenVersion != currentVersion) ? .whatsNew : .calculator
            }
        }
    }
}
