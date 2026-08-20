import SwiftUI

enum DesignTokens {
    enum Palette {
        static let calmBackground = Color(red: 0.97, green: 0.96, blue: 0.93)
        static let calmSurface = Color(red: 1.0, green: 0.99, blue: 0.97)
        static let calmAccent = Color(red: 0.36, green: 0.55, blue: 0.71)
        static let softInk = Color(red: 0.18, green: 0.20, blue: 0.24)
        static let mutedInk = Color(red: 0.42, green: 0.44, blue: 0.48)
        static let softShadow = Color.black.opacity(0.08)

        static let urgencyBackground = Color(red: 0.98, green: 0.90, blue: 0.83)
        static let urgencyAccent = Color(red: 0.86, green: 0.36, blue: 0.24)
        static let urgencyDeep = Color(red: 0.66, green: 0.20, blue: 0.16)

        static let successAccent = Color(red: 0.28, green: 0.62, blue: 0.45)
    }

    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 12
        static let md: CGFloat = 20
        static let lg: CGFloat = 32
        static let xl: CGFloat = 48
    }

    enum Radius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 18
        static let lg: CGFloat = 28
    }

    enum FontScale {
        static let title = Font.system(.largeTitle, design: .rounded).weight(.semibold)
        static let heading = Font.system(.title, design: .rounded).weight(.semibold)
        static let body = Font.system(.body, design: .rounded)
        static let caption = Font.system(.footnote, design: .rounded)
        static let button = Font.system(.headline, design: .rounded).weight(.semibold)
    }

    enum Motion {
        static let easeGentle: Animation = .easeInOut(duration: 0.55)
        static let spring: Animation = .spring(response: 0.5, dampingFraction: 0.75)
        static let quick: Animation = .easeInOut(duration: 0.25)
    }
}
