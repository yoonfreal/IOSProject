import SwiftUI

enum Screen: Int, CaseIterable {
    case normalDay
    case prepRoom
    case unpreparedRoom
    case earthquake
    case choice
    case dropCoverHold
    case aftershock
    case aftermath
    case inspectDamage
    case outdoorSafety
    case staySafe
}

@Observable
final class AppState {
    var currentScreen: Screen = .normalDay

    func advance(to screen: Screen) {
        withAnimation(DesignTokens.Motion.easeGentle) {
            currentScreen = screen
        }
    }

    func advanceToNext() {
        let next = Screen(rawValue: currentScreen.rawValue + 1) ?? .normalDay
        advance(to: next)
    }

    func restart() {
        withAnimation(DesignTokens.Motion.easeGentle) {
            currentScreen = .normalDay
        }
    }
}
