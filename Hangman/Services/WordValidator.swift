import UIKit

enum WordValidator {
    static func isRealWord(_ word: String) -> Bool {
        let lowered = word.lowercased()
        guard !lowered.isEmpty, lowered.allSatisfy({ $0.isLetter }) else { return false }
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: lowered.utf16.count)
        let misspelled = checker.rangeOfMisspelledWord(
            in: lowered, range: range,
            startingAt: 0, wrap: false, language: "en"
        )
        return misspelled.location == NSNotFound
    }
}
