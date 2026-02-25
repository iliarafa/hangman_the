import SwiftUI

struct HangmanFigure: View {
    let wrongGuessCount: Int

    private let lineWidth: CGFloat = 3.5
    private let gallowsColor = Color.primary

    var body: some View {
        ZStack {
            GallowsShape()
                .stroke(gallowsColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))

            animatedPart(HeadShape(), visible: wrongGuessCount >= 1, color: .red)
            animatedPart(BodyShape(), visible: wrongGuessCount >= 2, color: .red)
            animatedPart(LeftArmShape(), visible: wrongGuessCount >= 3, color: .red)
            animatedPart(RightArmShape(), visible: wrongGuessCount >= 4, color: .red)
            animatedPart(LeftLegShape(), visible: wrongGuessCount >= 5, color: .red)
            animatedPart(RightLegShape(), visible: wrongGuessCount >= 6, color: .red)
        }
        .aspectRatio(0.7, contentMode: .fit)
    }

    @ViewBuilder
    private func animatedPart<S: Shape>(_ shape: S, visible: Bool, color: Color) -> some View {
        shape
            .trim(from: 0, to: visible ? 1 : 0)
            .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .animation(.spring(duration: 0.4, bounce: 0.3), value: visible)
    }
}

#Preview {
    VStack(spacing: 20) {
        HangmanFigure(wrongGuessCount: 6)
            .frame(height: 300)
    }
    .padding()
}
