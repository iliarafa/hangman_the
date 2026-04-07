import SwiftUI

struct HistoryScreen: View {
    let scoreManager: ScoreManager

    @Environment(\.dismiss) private var dismiss

    private var history: [GameRecord] { scoreManager.gameHistory }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withoutNavAnimation { dismiss() }
                } label: {
                    Text("< BACK")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.horizontal)

            ASCIITitleBox("HISTORY")
                .padding(.top, 16)

            if history.isEmpty {
                Spacer()
                Text("No games played yet")
                    .font(AppTheme.font(size: 18))
                    .secondaryStyle()
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(history) { record in
                            gameRow(record)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
            }
        }
        .padding(.top)
        .navigationBarBackButtonHidden(true)
    }

    private func gameRow(_ record: GameRecord) -> some View {
        HStack {
            Text(record.won ? "W" : "L")
                .font(AppTheme.font(size: 18))
                .foregroundStyle(record.won
                    ? Color(red: 0.0, green: 0.5, blue: 0.0)
                    : .primary.opacity(AppTheme.secondaryOpacity))

            Text(record.word.uppercased())
                .font(AppTheme.font(size: 18))
                .bodyStyle()
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("\(record.wrongGuessCount) wrong")
                .font(AppTheme.font(size: 14))
                .secondaryStyle()

            Text(record.date.formatted(.dateTime.month(.abbreviated).day()))
                .font(AppTheme.font(size: 14))
                .tertiaryStyle()
        }
        .padding(.vertical, 8)
    }
}
