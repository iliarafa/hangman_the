import SwiftUI

// MARK: - VT323 Font Helpers

/// VT323 is a single-weight pixel font, so we use grayscale opacity
/// to create visual hierarchy instead of font weight.
enum AppTheme {

    // MARK: - Font Name

    /// The PostScript name of the VT323 font.
    /// Falls back to system monospaced if the font fails to load.
    static let fontName = "VT323-Regular"

    // MARK: - Grayscale Hierarchy
    //
    // Since VT323 has no bold variant, we differentiate text importance
    // using brightness/opacity levels:
    //
    //   headline  : full white  (1.0) -- titles, key numbers, results
    //   body      : bright gray (0.85) -- standard interactive text
    //   secondary : mid gray    (0.55) -- labels, hints, less important
    //   tertiary  : dim gray    (0.35) -- dividers, disabled, decorative

    static let headlineOpacity: Double = 1.0
    static let bodyOpacity: Double = 0.85
    static let secondaryOpacity: Double = 0.55
    static let tertiaryOpacity: Double = 0.35

    // MARK: - Font Constructors

    static func font(size: CGFloat) -> Font {
        .custom(fontName, size: size)
    }
}

// MARK: - View Extensions

extension View {
    /// Apply VT323 font at a given size.
    func vt323(_ size: CGFloat) -> some View {
        self.font(.custom(AppTheme.fontName, size: size))
    }

    /// Apply headline-level grayscale (full brightness).
    func headlineStyle() -> some View {
        self.foregroundStyle(.primary.opacity(AppTheme.headlineOpacity))
    }

    /// Apply body-level grayscale (slightly dimmed).
    func bodyStyle() -> some View {
        self.foregroundStyle(.primary.opacity(AppTheme.bodyOpacity))
    }

    /// Apply secondary-level grayscale (noticeably dimmed).
    func secondaryStyle() -> some View {
        self.foregroundStyle(.primary.opacity(AppTheme.secondaryOpacity))
    }

    /// Apply tertiary-level grayscale (quite dim).
    func tertiaryStyle() -> some View {
        self.foregroundStyle(.primary.opacity(AppTheme.tertiaryOpacity))
    }
}
