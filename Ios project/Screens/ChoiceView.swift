import SwiftUI

enum QuakeChoice {
    case none, runOutside, hideUnderTable, standByWindow, takeElevator, rushStairs
}

struct ChoiceView: View {
    var onCorrectChoice: () -> Void

    @State private var selectedChoice: QuakeChoice = .none
    @State private var showConsequence = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("What do you do?")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                        .multilineTextAlignment(.center)
                    Text("Only one choice keeps you safe.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)

                VStack(spacing: DesignTokens.Spacing.sm) {
                    ChoiceCard(
                        symbol: "figure.run",
                        title: "Run outside",
                        subtitle: "Get out of the building fast."
                    ) {
                        pickChoice(.runOutside)
                    }
                    ChoiceCard(
                        symbol: "rectangle.portrait.on.rectangle.portrait",
                        title: "Stand by the window",
                        subtitle: "See what's going on outside."
                    ) {
                        pickChoice(.standByWindow)
                    }
                    ChoiceCard(
                        symbol: "arrow.up.and.down.square",
                        title: "Use the elevator",
                        subtitle: "Ride it down to leave the building."
                    ) {
                        pickChoice(.takeElevator)
                    }
                    ChoiceCard(
                        symbol: "figure.stairs",
                        title: "Rush for the stairs",
                        subtitle: "Sprint down to the ground floor."
                    ) {
                        pickChoice(.rushStairs)
                    }
                    ChoiceCard(
                        symbol: "tablecells",
                        title: "Hide under the table",
                        subtitle: "Take cover from falling debris."
                    ) {
                        pickChoice(.hideUnderTable)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.md)

                Spacer(minLength: DesignTokens.Spacing.md)
            }
            .opacity(showConsequence ? 0 : 1)

            if showConsequence {
                consequenceOverlay
                    .transition(.opacity)
            }
        }
    }

    @ViewBuilder
    private var consequenceOverlay: some View {
        switch selectedChoice {
        case .runOutside:
            RunOutsideConsequence()
        case .standByWindow:
            StandByWindowConsequence()
        case .takeElevator:
            TakeElevatorConsequence()
        case .rushStairs:
            RushStairsConsequence()
        default:
            EmptyView()
        }
    }

    private func pickChoice(_ choice: QuakeChoice) {
        guard selectedChoice == .none else { return }
        selectedChoice = choice
        switch choice {
        case .hideUnderTable:
            onCorrectChoice()
        case .runOutside, .standByWindow, .takeElevator, .rushStairs:
            withAnimation(DesignTokens.Motion.quick) {
                showConsequence = true
            }
            Task {
                try? await Task.sleep(for: .seconds(5))
                withAnimation(DesignTokens.Motion.easeGentle) {
                    showConsequence = false
                    selectedChoice = .none
                }
            }
        case .none:
            break
        }
    }
}

private struct ChoiceCard: View {
    var symbol: String
    var title: String
    var subtitle: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(DesignTokens.Palette.urgencyAccent.opacity(0.12))
                    )
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(DesignTokens.FontScale.button)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                    Text(subtitle)
                        .font(DesignTokens.FontScale.caption)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(DesignTokens.Palette.mutedInk.opacity(0.5))
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(DesignTokens.Palette.calmSurface)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 10, y: 4)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(title). \(subtitle)")
    }
}

private struct RunOutsideConsequence: View {
    @State private var runnerAdvanced = false
    @State private var runnerStumbled = false
    @State private var debrisFalling = false
    @State private var signSwinging = false
    @State private var legSwing = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Text("Debris rains from above!")
                    .font(DesignTokens.FontScale.heading)
                    .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    .multilineTextAlignment(.center)

                GeometryReader { proxy in
                    sceneContent(width: proxy.size.width, height: proxy.size.height)
                }
                .aspectRatio(4.0 / 3.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                Text("Outside isn't safer while it's shaking. Try again.")
                    .font(DesignTokens.FontScale.body)
                    .foregroundStyle(DesignTokens.Palette.mutedInk)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.25).repeatForever(autoreverses: true)) {
                legSwing = true
            }
            withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                signSwinging = true
            }
            runnerAdvanced = true
            debrisFalling = true
            Task {
                try? await Task.sleep(for: .seconds(0.75))
                withAnimation(.spring(response: 0.28, dampingFraction: 0.55)) {
                    runnerStumbled = true
                }
            }
        }
        .accessibilityLabel("Wrong choice. Glass, signage, and cornice fragments fall from the building as the person tries to run outside during the shaking.")
    }

    @ViewBuilder
    private func sceneContent(width w: CGFloat, height h: CGFloat) -> some View {
        let groundY = h * 0.88

        ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color(red: 0.90, green: 0.94, blue: 0.98))

            Rectangle()
                .fill(Color(red: 0.78, green: 0.78, blue: 0.76))
                .frame(height: h - groundY)
                .frame(maxHeight: .infinity, alignment: .bottom)

            BuildingFacadeShape()
                .frame(width: w * 0.48, height: h * 0.94)
                .position(x: w * 0.80, y: (h * 0.94) / 2)

            HangingSignShape(swing: signSwinging)
                .frame(width: w * 0.18, height: h * 0.12)
                .position(x: w * 0.60, y: h * 0.22)

            ForEach(0..<5, id: \.self) { i in
                fallingShard(index: i, width: w, height: h, groundY: groundY)
            }

            fallingCornice(width: w, height: h, groundY: groundY)

            RunnerShape(legSwing: legSwing, stopped: runnerStumbled)
                .frame(width: w * 0.16, height: h * 0.42)
                .scaleEffect(x: -1, y: 1)
                .rotationEffect(.degrees(runnerStumbled ? 16 : 0), anchor: .bottom)
                .position(
                    x: runnerAdvanced ? w * 0.22 : w * 0.55,
                    y: groundY - (h * 0.42) / 2
                )
                .animation(.easeInOut(duration: 1.0), value: runnerAdvanced)

            if runnerStumbled {
                Text("!")
                    .font(.system(size: 32, weight: .heavy, design: .rounded))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .position(x: w * 0.16, y: groundY - h * 0.55)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
    }

    private func fallingShard(index i: Int, width w: CGFloat, height h: CGFloat, groundY: CGFloat) -> some View {
        let startX = w * (0.32 + CGFloat(i) * 0.09)
        let startY = h * (0.02 + CGFloat(i % 2) * 0.05)
        let endX = startX + CGFloat(i - 2) * 6
        let endY = groundY - CGFloat(i % 2) * 6
        let rotation = Double(i) * 47 - 30
        return FallingGlassShardShape()
            .fill(Color(red: 0.68, green: 0.82, blue: 0.92).opacity(0.9))
            .frame(width: 14, height: 22)
            .rotationEffect(.degrees(debrisFalling ? rotation : 0))
            .position(
                x: debrisFalling ? endX : startX,
                y: debrisFalling ? endY : startY
            )
            .shadow(color: DesignTokens.Palette.softShadow, radius: 1, y: 1)
            .animation(.easeIn(duration: 0.85).delay(Double(i) * 0.12), value: debrisFalling)
    }

    private func fallingCornice(width w: CGFloat, height h: CGFloat, groundY: CGFloat) -> some View {
        let startY = h * 0.10
        let endY = groundY - 8
        return RoundedRectangle(cornerRadius: 3)
            .fill(Color(red: 0.66, green: 0.62, blue: 0.56))
            .frame(width: w * 0.14, height: h * 0.035)
            .rotationEffect(.degrees(debrisFalling ? 42 : 0))
            .position(
                x: w * 0.50,
                y: debrisFalling ? endY : startY
            )
            .shadow(color: DesignTokens.Palette.softShadow, radius: 2, y: 2)
            .animation(.easeIn(duration: 0.95).delay(0.2), value: debrisFalling)
    }
}

private struct BuildingFacadeShape: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.78, green: 0.74, blue: 0.68))
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)

                VStack(spacing: h * 0.04) {
                    ForEach(0..<5, id: \.self) { _ in
                        HStack(spacing: w * 0.10) {
                            ForEach(0..<2, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.55, green: 0.68, blue: 0.78))
                                    .frame(height: h * 0.08)
                            }
                        }
                        .padding(.horizontal, w * 0.10)
                    }
                }
                .padding(.top, h * 0.08)
            }
        }
    }
}

private struct HangingSignShape: View {
    var swing: Bool

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            VStack(spacing: 0) {
                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.55))
                    .frame(width: 2, height: h * 0.20)
                RoundedRectangle(cornerRadius: 4)
                    .fill(DesignTokens.Palette.urgencyAccent)
                    .frame(width: w, height: h * 0.72)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 2, y: 2)
            }
            .rotationEffect(.degrees(swing ? 10 : -10), anchor: .top)
        }
    }
}

private struct FallingGlassShardShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.midX + rect.width * 0.15, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.midY + rect.height * 0.10))
        p.closeSubpath()
        return p
    }
}

private struct RunnerShape: View {
    var legSwing: Bool
    var stopped: Bool

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.5, y: h * 0.14)

                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.5, height: h * 0.42)
                    .rotationEffect(.degrees(stopped ? 0 : -8), anchor: .top)
                    .position(x: w * 0.5, y: h * 0.42)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.18, height: h * 0.30)
                    .rotationEffect(.degrees(stopped ? -10 : (legSwing ? 30 : -20)), anchor: .top)
                    .position(x: w * 0.42, y: h * 0.72)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.18, height: h * 0.30)
                    .rotationEffect(.degrees(stopped ? 10 : (legSwing ? -20 : 30)), anchor: .top)
                    .position(x: w * 0.58, y: h * 0.72)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(stopped ? -70 : (legSwing ? -35 : 25)), anchor: .top)
                    .position(x: w * 0.30, y: h * 0.36)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(stopped ? -70 : (legSwing ? 25 : -35)), anchor: .top)
                    .position(x: w * 0.70, y: h * 0.36)
            }
        }
    }
}

private struct StandByWindowConsequence: View {
    @State private var crackProgress: CGFloat = 0
    @State private var personRecoils = false
    @State private var shardsBursting = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Text("The window shatters!")
                    .font(DesignTokens.FontScale.heading)
                    .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    .multilineTextAlignment(.center)

                GeometryReader { proxy in
                    windowScene(width: proxy.size.width, height: proxy.size.height)
                }
                .aspectRatio(4.0 / 3.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                Text("Try again.")
                    .font(DesignTokens.FontScale.body)
                    .foregroundStyle(DesignTokens.Palette.mutedInk)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9)) {
                crackProgress = 1
            }
            Task {
                try? await Task.sleep(for: .seconds(0.35))
                withAnimation(.spring(response: 0.25, dampingFraction: 0.55)) {
                    personRecoils = true
                }
                withAnimation(.easeOut(duration: 0.55)) {
                    shardsBursting = true
                }
            }
        }
        .accessibilityLabel("Wrong choice. The window shatters and glass shards fly toward the person standing beside it.")
    }

    @ViewBuilder
    private func windowScene(width w: CGFloat, height h: CGFloat) -> some View {
        let floorY = h * 0.88
        let windowSize = min(w * 0.28, h * 0.45)
        let windowCenterX = w * 0.62
        let windowCenterY = floorY - windowSize / 2 - h * 0.24
        let personTargetX = w * 0.30
        let personTargetY = floorY - h * 0.24

        ZStack {
            Rectangle()
                .fill(DesignTokens.Palette.mutedInk.opacity(0.2))
                .frame(height: 2)
                .position(x: w * 0.5, y: floorY)

            ChoiceCrackedWindow(crackProgress: crackProgress)
                .frame(width: windowSize, height: windowSize)
                .position(x: windowCenterX, y: windowCenterY)

            StandingPersonShape(recoiling: personRecoils)
                .frame(width: w * 0.14, height: h * 0.42)
                .position(
                    x: personRecoils ? w * 0.28 : w * 0.34,
                    y: floorY - (h * 0.42) / 2
                )
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: personRecoils)

            ForEach(0..<6, id: \.self) { i in
                shardProjectile(
                    index: i,
                    origin: CGPoint(x: windowCenterX, y: windowCenterY),
                    target: CGPoint(x: personTargetX, y: personTargetY),
                    height: h
                )
            }

            if personRecoils {
                Text("!")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .position(x: w * 0.32, y: floorY - h * 0.58)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private func shardProjectile(index i: Int, origin: CGPoint, target: CGPoint, height h: CGFloat) -> some View {
        let spread = CGFloat(i - 2) * (h * 0.045)
        let endX = target.x + CGFloat(i - 3) * 4
        let endY = target.y + spread
        let rotation = Double(i) * 46 - 40
        return FallingGlassShardShape()
            .fill(Color(red: 0.62, green: 0.78, blue: 0.88).opacity(0.9))
            .frame(width: 12, height: 20)
            .rotationEffect(.degrees(shardsBursting ? rotation : 0))
            .position(
                x: shardsBursting ? endX : origin.x,
                y: shardsBursting ? endY : origin.y
            )
            .opacity(shardsBursting ? 1 : 0)
            .shadow(color: DesignTokens.Palette.softShadow, radius: 1, y: 1)
    }
}

private struct RushStairsConsequence: View {
    @State private var personAdvanced = false
    @State private var stepShifted = false
    @State private var personFalls = false
    @State private var warningVisible = false
    @State private var legSwing = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Text("The steps give way!")
                    .font(DesignTokens.FontScale.heading)
                    .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    .multilineTextAlignment(.center)

                GeometryReader { proxy in
                    stairsScene(width: proxy.size.width, height: proxy.size.height)
                }
                .aspectRatio(4.0 / 3.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                Text("Stairs can crack or shift mid-shake. Wait until it stops.")
                    .font(DesignTokens.FontScale.body)
                    .foregroundStyle(DesignTokens.Palette.mutedInk)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            withAnimation(.linear(duration: 0.25).repeatForever(autoreverses: true)) {
                legSwing = true
            }
            personAdvanced = true
            Task {
                try? await Task.sleep(for: .seconds(0.65))
                withAnimation(.easeIn(duration: 0.35)) {
                    stepShifted = true
                }
                withAnimation(.spring(response: 0.28, dampingFraction: 0.48)) {
                    personFalls = true
                    warningVisible = true
                }
            }
        }
        .accessibilityLabel("Wrong choice. The staircase cracks and shifts mid-shake, and the person tumbles forward.")
    }

    @ViewBuilder
    private func stairsScene(width w: CGFloat, height h: CGFloat) -> some View {
        let stepWidth = w * 0.16
        let stepHeight = h * 0.08
        let stepTopX = w * 0.78
        let stepTopY = h * 0.32
        let stepDX = -stepWidth * 0.62
        let stepDY = stepHeight * 1.10

        ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color(red: 0.94, green: 0.94, blue: 0.96))

            ForEach(0..<5, id: \.self) { i in
                stairStep(
                    index: i,
                    origin: CGPoint(
                        x: stepTopX + CGFloat(i) * stepDX,
                        y: stepTopY + CGFloat(i) * stepDY
                    ),
                    stepWidth: stepWidth,
                    stepHeight: stepHeight
                )
            }

            RunnerShape(legSwing: legSwing, stopped: personFalls)
                .frame(width: w * 0.13, height: h * 0.34)
                .scaleEffect(x: -1, y: 1)
                .rotationEffect(.degrees(personFalls ? 55 : -6), anchor: .bottom)
                .position(
                    x: personAdvanced ? (personFalls ? w * 0.44 : w * 0.52) : w * 0.72,
                    y: personAdvanced ? (personFalls ? h * 0.66 : h * 0.48) : h * 0.34
                )
                .animation(.easeInOut(duration: 0.95), value: personAdvanced)

            if warningVisible {
                Text("!")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .position(x: w * 0.42, y: h * 0.24)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
    }

    private func stairStep(index i: Int, origin: CGPoint, stepWidth: CGFloat, stepHeight: CGFloat) -> some View {
        let isBrokenStep = i == 2
        let tilt: Double = (stepShifted && isBrokenStep) ? -14 : 0
        let yOffset: CGFloat = (stepShifted && isBrokenStep) ? 6 : 0
        return RoundedRectangle(cornerRadius: 4)
            .fill(Color(red: 0.72, green: 0.66, blue: 0.58))
            .frame(width: stepWidth, height: stepHeight)
            .rotationEffect(.degrees(tilt), anchor: .center)
            .position(x: origin.x, y: origin.y + yOffset)
            .shadow(color: DesignTokens.Palette.softShadow, radius: 2, y: 2)
    }
}

private struct TakeElevatorConsequence: View {
    @State private var cableBreaks = false
    @State private var carJolt = false
    @State private var lightsOut = false
    @State private var warningVisible = false

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Text("The power cuts — you're trapped!")
                    .font(DesignTokens.FontScale.heading)
                    .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    .multilineTextAlignment(.center)

                GeometryReader { proxy in
                    elevatorScene(width: proxy.size.width, height: proxy.size.height)
                }
                .aspectRatio(4.0 / 3.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                Text("Cables can snap and power can fail. Never use elevators during a quake.")
                    .font(DesignTokens.FontScale.body)
                    .foregroundStyle(DesignTokens.Palette.mutedInk)
                    .multilineTextAlignment(.center)
            }
            .padding(DesignTokens.Spacing.lg)
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(0.45))
                withAnimation(.easeIn(duration: 0.3)) {
                    cableBreaks = true
                }
                withAnimation(.spring(response: 0.2, dampingFraction: 0.42)) {
                    carJolt = true
                }
                try? await Task.sleep(for: .seconds(0.3))
                withAnimation(.easeInOut(duration: 0.4)) {
                    lightsOut = true
                    warningVisible = true
                }
            }
        }
        .accessibilityLabel("Wrong choice. The elevator cable snaps, the car jolts, and the lights cut out, trapping the person inside.")
    }

    @ViewBuilder
    private func elevatorScene(width w: CGFloat, height h: CGFloat) -> some View {
        let shaftWidth = w * 0.44
        let shaftHeight = h * 0.94
        let shaftX = w * 0.5
        let shaftTop = h * 0.03
        let shaftBottom = shaftTop + shaftHeight
        let carSize = min(shaftWidth * 0.72, shaftHeight * 0.32)
        let carY = h * 0.55
        let cableAttachY = carY - carSize / 2

        ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color(red: 0.94, green: 0.94, blue: 0.96))

            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                .fill(Color(red: 0.24, green: 0.24, blue: 0.28))
                .frame(width: shaftWidth, height: shaftHeight)
                .position(x: shaftX, y: shaftTop + shaftHeight / 2)

            ForEach(0..<3, id: \.self) { i in
                Rectangle()
                    .fill(Color(red: 0.16, green: 0.16, blue: 0.20))
                    .frame(width: shaftWidth, height: 2)
                    .position(x: shaftX, y: shaftTop + shaftHeight * (0.22 + CGFloat(i) * 0.24))
            }

            Path { p in
                p.move(to: CGPoint(x: shaftX, y: shaftTop + 8))
                p.addLine(to: CGPoint(x: shaftX, y: cableAttachY))
            }
            .trim(from: 0, to: cableBreaks ? 0.32 : 1.0)
            .stroke(Color(red: 0.85, green: 0.85, blue: 0.88), style: StrokeStyle(lineWidth: 3, lineCap: .round))

            if cableBreaks {
                Path { p in
                    let breakY = shaftTop + (cableAttachY - shaftTop - 8) * 0.32 + 8
                    p.move(to: CGPoint(x: shaftX, y: breakY))
                    p.addLine(to: CGPoint(x: shaftX - w * 0.04, y: breakY + h * 0.06))
                }
                .stroke(Color(red: 0.85, green: 0.85, blue: 0.88), style: StrokeStyle(lineWidth: 3, lineCap: .round))
                .transition(.opacity)
            }

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(lightsOut ? Color(red: 0.12, green: 0.12, blue: 0.16) : Color(red: 0.96, green: 0.90, blue: 0.68))
                    .frame(width: carSize, height: carSize)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 4, y: 3)

                Rectangle()
                    .fill(Color(red: 0.55, green: 0.55, blue: 0.60).opacity(0.55))
                    .frame(width: 1.5, height: carSize)

                ElevatorPersonShape(inDark: lightsOut)
                    .frame(width: carSize * 0.32, height: carSize * 0.68)
            }
            .offset(y: carJolt ? 10 : 0)
            .position(x: shaftX, y: carY)

            if lightsOut {
                Text("⚡")
                    .font(.system(size: 26, weight: .heavy))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .position(x: shaftX + shaftWidth * 0.30, y: shaftTop + shaftHeight * 0.14)
                    .transition(.opacity.combined(with: .scale))
            }

            if warningVisible {
                Text("!")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                    .position(x: shaftX + shaftWidth * 0.48, y: carY - carSize * 0.55)
                    .transition(.scale.combined(with: .opacity))
            }

            Rectangle()
                .fill(Color(red: 0.55, green: 0.55, blue: 0.55))
                .frame(width: w, height: 2)
                .position(x: w * 0.5, y: shaftBottom)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
    }
}

private struct ElevatorPersonShape: View {
    var inDark: Bool

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            let strokeColor: Color = inDark ? DesignTokens.Palette.softInk.opacity(0.55) : DesignTokens.Palette.softInk
            let bodyColor: Color = inDark ? DesignTokens.Palette.softInk.opacity(0.55) : DesignTokens.Palette.calmAccent
            ZStack {
                Circle()
                    .fill(strokeColor)
                    .frame(width: w * 0.85, height: w * 0.85)
                    .position(x: w * 0.5, y: h * 0.16)

                Capsule()
                    .fill(bodyColor)
                    .frame(width: w * 0.85, height: h * 0.52)
                    .position(x: w * 0.5, y: h * 0.52)

                Capsule()
                    .fill(strokeColor)
                    .frame(width: w * 0.30, height: h * 0.32)
                    .position(x: w * 0.36, y: h * 0.86)

                Capsule()
                    .fill(strokeColor)
                    .frame(width: w * 0.30, height: h * 0.32)
                    .position(x: w * 0.64, y: h * 0.86)
            }
        }
    }
}

private struct StandingPersonShape: View {
    var recoiling: Bool

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.5, y: h * 0.12)

                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.5, height: h * 0.4)
                    .rotationEffect(.degrees(recoiling ? -8 : 0), anchor: .bottom)
                    .position(x: w * 0.5, y: h * 0.4)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.28)
                    .rotationEffect(.degrees(recoiling ? -6 : 0), anchor: .top)
                    .position(x: w * 0.42, y: h * 0.68)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.28)
                    .rotationEffect(.degrees(recoiling ? 6 : 0), anchor: .top)
                    .position(x: w * 0.58, y: h * 0.68)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(recoiling ? -60 : 25), anchor: .top)
                    .position(x: w * 0.34, y: h * 0.36)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(recoiling ? -80 : 45), anchor: .top)
                    .position(x: w * 0.66, y: h * 0.36)
            }
        }
    }
}

private struct ChoiceCrackedWindow: View {
    var crackProgress: CGFloat

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(red: 0.82, green: 0.89, blue: 0.94))
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(DesignTokens.Palette.softInk.opacity(0.20), lineWidth: 2)

                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.12))
                    .frame(width: 2)
                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.12))
                    .frame(height: 2)

                ChoiceCrackShape()
                    .trim(from: 0, to: crackProgress)
                    .stroke(
                        DesignTokens.Palette.softInk.opacity(0.75),
                        style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round)
                    )
                    .padding(6)

                HStack(spacing: 0) {
                    ChoiceCurtainShape()
                        .fill(Color(red: 0.94, green: 0.85, blue: 0.76))
                        .frame(width: w * 0.32)
                    Spacer()
                    ChoiceCurtainShape()
                        .fill(Color(red: 0.94, green: 0.85, blue: 0.76))
                        .frame(width: w * 0.32)
                        .scaleEffect(x: -1, anchor: .center)
                }
                .frame(width: w, height: h)
                .padding(4)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            }
        }
    }
}

private struct ChoiceCurtainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: 0))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.55, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 1.35, y: rect.maxY * 0.55)
        )
        p.addLine(to: CGPoint(x: 0, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct ChoiceCrackShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.minY + rect.height * 0.20))
        p.addLine(to: CGPoint(x: rect.midX * 0.9, y: rect.midY * 0.9))
        p.addLine(to: CGPoint(x: rect.midX * 1.1, y: rect.midY * 1.15))
        p.addLine(to: CGPoint(x: rect.maxX * 0.85, y: rect.maxY * 0.65))

        p.move(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX * 0.3, y: rect.maxY * 0.85))

        p.move(to: CGPoint(x: rect.midX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.maxX * 0.7, y: rect.maxY * 0.25))
        return p
    }
}

#Preview {
    ChoiceView(onCorrectChoice: {})
}
