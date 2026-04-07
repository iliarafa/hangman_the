import SwiftUI

struct PixelFloodView: View {
    enum Phase { case flooding, retreating }
    let phase: Phase
    let onComplete: () -> Void

    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var startTime: Date = .now

    private let blockSize: CGFloat = 4
    private let duration: TimeInterval = 0.45

    var body: some View {
        if reduceMotion {
            Color.clear
                .ignoresSafeArea()
                .onAppear { onComplete() }
        } else {
            animatedContent
        }
    }

    private var animatedContent: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date.timeIntervalSince(startTime)
                let progress = min(elapsed / duration, 1.0)

                let cols = Int(ceil(size.width / blockSize))
                let rows = Int(ceil(size.height / blockSize))
                let fillColor = colorScheme == .dark ? Color.white : Color.black

                for row in 0..<rows {
                    for col in 0..<cols {
                        let rowNorm = CGFloat(rows - 1 - row) / max(CGFloat(rows - 1), 1)
                        let jitter = CGFloat((col * 7 + row * 13) % 17) / 17.0 * 0.08
                        let threshold = rowNorm + jitter

                        let visible: Bool
                        switch phase {
                        case .flooding:
                            visible = progress * 1.1 > threshold
                        case .retreating:
                            visible = progress * 1.1 <= threshold
                        }

                        guard visible else { continue }

                        let rect = CGRect(
                            x: CGFloat(col) * blockSize,
                            y: CGFloat(row) * blockSize,
                            width: blockSize,
                            height: blockSize
                        )
                        context.fill(Rectangle().path(in: rect), with: .color(fillColor))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .task {
            try? await Task.sleep(for: .seconds(duration + 0.02))
            onComplete()
        }
    }
}
