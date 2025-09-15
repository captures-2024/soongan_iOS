import SwiftUI

public struct SkeletonView: View {
    @State private var isAnimating = false

    private var animation: Animation {
        Animation.linear(duration: 2.0).repeatForever(autoreverses: false)
    }

    public init() {}

    public var body: some View {
        let baseColor = Color.backgroundGray
        let highlightColor = Color.black60.opacity(0.3)

        let gradient = LinearGradient(
            gradient: Gradient(stops: [
                .init(color: baseColor, location: 0),
                .init(color: highlightColor, location: 0.4),
                .init(color: highlightColor, location: 0.6),
                .init(color: baseColor, location: 1.0)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )

        Rectangle()
            .fill(baseColor)
            .overlay(
                Rectangle()
                    .fill(gradient)
                    .scaleEffect(x: 3, y: 1, anchor: .center)
                    .offset(x: isAnimating ? 500 : -500)
                    .animation(animation, value: isAnimating)
            )
            .onAppear {
                withAnimation(animation) {
                    isAnimating = true
                }
            }
            .clipped()
    }
}

#Preview {
    SkeletonView()
        .frame(height: 100)
        .cornerRadius(8)
}
