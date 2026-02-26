import SwiftUI

// MARK: - Bracket Button

enum ASCIIButtonStyle {
    case primary
    case body
    case secondary
}

struct ASCIIBracketButton: ViewModifier {
    let style: ASCIIButtonStyle
    let fontSize: CGFloat

    init(_ style: ASCIIButtonStyle = .primary, fontSize: CGFloat = 18) {
        self.style = style
        self.fontSize = fontSize
    }

    private var textOpacity: Double {
        switch style {
        case .primary: return AppTheme.headlineOpacity
        case .body: return AppTheme.bodyOpacity
        case .secondary: return AppTheme.secondaryOpacity
        }
    }

    func body(content: Content) -> some View {
        content
            .fixedSize()
            .padding(.horizontal, fontSize * 1.2)
            .overlay(alignment: .leading) {
                Text("[")
                    .font(AppTheme.font(size: fontSize))
                    .foregroundStyle(.primary.opacity(textOpacity))
            }
            .overlay(alignment: .trailing) {
                Text("]")
                    .font(AppTheme.font(size: fontSize))
                    .foregroundStyle(.primary.opacity(textOpacity))
            }
            .font(AppTheme.font(size: fontSize))
            .foregroundStyle(.primary.opacity(textOpacity))
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
            .font(AppTheme.font(size: 14))
            .tertiaryStyle()
            .frame(maxWidth: .infinity)
    }
}

// MARK: - ASCII Title Box

struct ASCIITitleBox: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(AppTheme.font(size: 36))
            .headlineStyle()
            .minimumScaleFactor(0.5)
            .lineLimit(1)
    }
}

// MARK: - ASCII Text Field

struct ASCIITextField: View {
    let placeholder: String
    @Binding var text: String
    var slotCount: Int = 12
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 0) {
            Text("> ")
                .font(AppTheme.font(size: 20))
                .secondaryStyle()

            HStack(spacing: 4) {
                let chars = Array(text)
                ForEach(0..<slotCount, id: \.self) { i in
                    VStack(spacing: -10) {
                        let placeholderChars = Array(placeholder)
                        if i < chars.count {
                            Text(String(chars[i]))
                                .font(AppTheme.font(size: 20))
                                .headlineStyle()
                        } else if text.isEmpty && i < placeholderChars.count {
                            Text(String(placeholderChars[i]))
                                .font(AppTheme.font(size: 20))
                                .foregroundStyle(.primary.opacity(AppTheme.tertiaryOpacity))
                        } else {
                            Text(" ")
                                .font(AppTheme.font(size: 20))
                        }
                        Text("_")
                            .font(AppTheme.font(size: 20))
                            .foregroundStyle(.primary.opacity(i < chars.count ? AppTheme.bodyOpacity : AppTheme.tertiaryOpacity))
                    }
                }
            }
        }
        .fixedSize()
        .contentShape(Rectangle())
        .onTapGesture { isFocused = true }
        .padding(.vertical, 12)
        .background {
            TextField("", text: $text)
                .focused($isFocused)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.words)
                .opacity(0)
                .onChange(of: text) {
                    if text.count > slotCount {
                        text = String(text.prefix(slotCount))
                    }
                }
        }
    }
}

struct ASCIITextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            Text("> ")
                .font(AppTheme.font(size: 20))
                .secondaryStyle()
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
