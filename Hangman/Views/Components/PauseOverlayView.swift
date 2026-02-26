import SwiftUI

extension Notification.Name {
    static let navigateToHome = Notification.Name("navigateToHome")
}

struct PauseOverlayView: View {
    @Binding var isPresented: Bool
    var onGoHome: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.85)
                .ignoresSafeArea()

            VStack(spacing: 32) {
                ASCIITitleBox("PAUSED")

                VStack(spacing: 16) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("RESUME")
                            .asciiBracket(.primary, fontSize: 24)
                            .foregroundStyle(Color(red: 0.0, green: 0.5, blue: 0.0))
                    }

                    Button {
                        onGoHome()
                    } label: {
                        Text("HOMESCREEN")
                            .asciiBracket(.secondary, fontSize: 24)
                    }
                }
            }
        }
    }
}
