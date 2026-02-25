import SwiftUI

// MARK: - Bracket Button

enum ASCIIButtonStyle {
    case primary
    case secondary
}

struct ASCIIBracketButton: ViewModifier {
    let style: ASCIIButtonStyle
    let fontSize: CGFloat

    init(_ style: ASCIIButtonStyle = .primary, fontSize: CGFloat = 18) {
        self.style = style
        self.fontSize = fontSize
    }

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Text("[  ")
            content
            Text("  ]")
        }
        .font(.system(size: fontSize, weight: style == .primary ? .bold : .regular, design: .monospaced))
        .foregroundStyle(style == .primary ? .primary : .secondary)
    }
}

extension View {
    func asciiBracket(_ style: ASCIIButtonStyle = .primary, fontSize: CGFloat = 18) -> some View {
        modifier(ASCIIBracketButton(style, fontSize: fontSize))
    }
}

// MARK: - ASCII Divider

struct ASCIIDivider: View {
    var body: some View {
        Text("- - - - - - - - - - - - - - -")
            .font(.system(size: 14, design: .monospaced))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - ASCII Title Box

struct ASCIITitleBox: View {
    let text: String
    let charWidth: Int

    init(_ text: String, charWidth: Int = 30) {
        self.text = text
        self.charWidth = charWidth
    }

    var body: some View {
        let innerWidth = max(charWidth, text.count + 4)
        let bar = String(repeating: "\u{2550}", count: innerWidth)
        let emptyFill = String(repeating: " ", count: innerWidth)

        VStack(spacing: 0) {
            Text("\u{2554}" + bar + "\u{2557}")
            Text("\u{2551}" + emptyFill + "\u{2551}")
            Text("\u{255A}" + bar + "\u{255D}")
        }
        .font(.system(size: 16, weight: .bold, design: .monospaced))
        .foregroundStyle(.primary)
        .overlay {
            Text(text)
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.primary)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
}

// MARK: - ASCII Text Field

struct ASCIITextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Text("> ")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)
            content
        }
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            ASCIIDivider()
        }
    }
}

extension View {
    func asciiTextField() -> some View {
        modifier(ASCIITextFieldStyle())
    }
}

// MARK: - ASCII Art

enum ASCIIArt {
    static let trophy = """
         ___________
        '._==_==_=_.'
        .-\\:      /-.
       | (|:.     |) |
        '-|:.     |-'
          \\::.    /
           '::. .'
             ) (
           _.' '._
          '-------'
    """

    static let skull = """
          _____
         /     \\
        | () () |
         \\  ^  /
          |||||
          |||||
    """
}

// MARK: - ASCII Stat Row

func asciiStatRow(title: String, value: String, totalWidth: Int = 32) -> String {
    let contentLength = title.count + value.count
    let dotCount = max(2, totalWidth - contentLength)
    let dots = " " + String(repeating: ".", count: dotCount) + " "
    return title + dots + value
}
