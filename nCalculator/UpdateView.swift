
import SwiftUI

struct Feature: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
}




struct UpdateView: View {
    
    var onContinue: () -> Void
    
    let features = [
            Feature(icon: "paintpalette.fill",
                    title: "New Theme",
                    description: "Fresh gradient Background"),
            Feature(icon: "square.and.arrow.down", title: "Update screen", description: "Added this update screen to showcase new features"),
            Feature(icon: "percent",
                    title: "Percentage Calculation",
                    description: "You can now calculate percentages in the claculator"),
            Feature(icon: "bolt.fill",
                    title: "Faster",
                    description: "The app now launches quicker."),

        ]
    
    var body: some View {
        VStack(spacing: 30) {
                    Text("What's New")
                        .font(.largeTitle.bold())
                        .padding(.top, 40)
                    Text("1.0")
                .font(.title)
                .padding()

                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(features) { feature in
                            HStack(spacing: 16) {
                                Image(systemName: feature.icon)
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                    .frame(width: 44)

                                VStack(alignment: .leading) {
                                    Text(feature.title).font(.headline)
                                    Text(feature.description)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()

                    Button("Continue") {
                        onContinue()
                    }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.black.opacity(0.8))
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                    .padding(.bottom)
                    
            }
        .background(
            LinearGradient(
                colors: [.nyxYellow, .nyxCyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

}

#Preview {
    UpdateView(onContinue: {})
}
