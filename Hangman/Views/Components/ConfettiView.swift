import SwiftUI

struct ConfettiPiece: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let color: Color
    let size: CGFloat
    let rotation: Double
    let speed: CGFloat
    let horizontalDrift: CGFloat
}

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    @State private var animate = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink, .mint]

    var body: some View {
        if reduceMotion {
            EmptyView()
        } else {
            animatedContent
        }
    }

    private var animatedContent: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = animate
                    ? timeline.date.timeIntervalSinceReferenceDate
                    : 0

                for piece in pieces {
                    let progress = elapsed.truncatingRemainder(dividingBy: 4) / 4
                    let yOffset = piece.speed * CGFloat(progress) * size.height
                    let xOffset = sin(CGFloat(progress) * .pi * 2 + piece.horizontalDrift) * 30

                    let currentX = piece.x * size.width + xOffset
                    let currentY = -piece.size + yOffset

                    guard currentY < size.height + piece.size else { continue }

                    var contextCopy = context
                    contextCopy.translateBy(x: currentX, y: currentY)
                    contextCopy.rotate(by: .degrees(piece.rotation + Double(progress) * 360))

                    let rect = CGRect(
                        x: -piece.size / 2,
                        y: -piece.size / 2,
                        width: piece.size,
                        height: piece.size * 0.6
                    )
                    contextCopy.fill(
                        RoundedRectangle(cornerRadius: 2).path(in: rect),
                        with: .color(piece.color)
                    )
                }
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onAppear {
            pieces = (0..<60).map { _ in
                ConfettiPiece(
                    x: CGFloat.random(in: 0...1),
                    y: CGFloat.random(in: -0.5...0),
                    color: colors.randomElement()!,
                    size: CGFloat.random(in: 6...12),
                    rotation: Double.random(in: 0...360),
                    speed: CGFloat.random(in: 0.8...1.5),
                    horizontalDrift: CGFloat.random(in: 0...(.pi * 2))
                )
            }
            animate = true
        }
    }
}

#Preview {
    ConfettiView()
}
