import SwiftUI

struct ContentView: View {
    @State private var appState = AppState()

    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .normalDay:
                NormalDayView(onStart: { appState.advance(to: .prepRoom) })
                    .transition(.opacity)
            case .prepRoom:
                PrepRoomView(onContinue: { appState.advance(to: .unpreparedRoom) })
                    .transition(.opacity)
            case .unpreparedRoom:
                UnpreparedRoomView(onContinue: { appState.advance(to: .earthquake) })
                    .transition(.opacity)
            case .earthquake:
                EarthquakeView(onContinue: { appState.advance(to: .choice) })
                    .transition(.opacity)
            case .choice:
                ChoiceView(onCorrectChoice: { appState.advance(to: .dropCoverHold) })
                    .transition(.opacity)
            case .dropCoverHold:
                DropCoverHoldView(onContinue: { appState.advance(to: .aftershock) })
                    .transition(.opacity)
            case .aftershock:
                AftershockView(onContinue: { appState.advance(to: .aftermath) })
                    .transition(.opacity)
            case .aftermath:
                AftermathView(onContinue: { appState.advance(to: .inspectDamage) })
                    .transition(.opacity)
            case .inspectDamage:
                InspectDamageView(onContinue: { appState.advance(to: .outdoorSafety) })
                    .transition(.opacity)
            case .outdoorSafety:
                OutdoorSafetyView(onContinue: { appState.advance(to: .staySafe) })
                    .transition(.opacity)
            case .staySafe:
                StaySafeView(onReplay: { appState.restart() })
                    .transition(.opacity)
            }
        }
    }
}

#Preview {
    ContentView()
}
