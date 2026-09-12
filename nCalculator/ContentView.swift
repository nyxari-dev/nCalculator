
import SwiftUI

struct SplashView: View {
    let color1 = Color(hex: 0xFFD479)
    let color2 = Color(hex: 0x73FDFF)

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [color1, color2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            HStack(spacing: 10) {
                Image("NCalLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 9))

                Text("NyxCalculator")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.black.opacity(0.8))
            }
            .padding()
        }
    }
}

extension Color {
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
