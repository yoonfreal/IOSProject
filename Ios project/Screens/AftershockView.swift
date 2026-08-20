import SwiftUI

struct AftershockView: View {
    var onContinue: () -> Void

    @State private var shelfFallen = false
    @State private var booksFalling = false
    @State private var glassShatter = false
    @State private var wallCracked = false
    @State private var buttonVisible = false
    @State private var shakeOffset: CGSize = .zero
    @State private var tintPulse: CGFloat = 0
    @State private var curtainSway: Double = -5

    var body: some View {
        ZStack {
            DesignTokens.Palette.urgencyBackground.ignoresSafeArea()

            DesignTokens.Palette.urgencyAccent
                .opacity(0.10 + 0.15 * tintPulse)
                .ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("The room comes apart")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                        .multilineTextAlignment(.center)
                    Text("The shelf topples onto the table. Glass shatters across the room. The table keeps you safe.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                }

                stage
                    .offset(shakeOffset)
                    .padding(.horizontal, DesignTokens.Spacing.md)

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle(tint: DesignTokens.Palette.urgencyAccent))
                    .opacity(buttonVisible ? 1 : 0)
                    .disabled(!buttonVisible)
                    .accessibilityLabel("Continue to the aftermath")

                Spacer(minLength: DesignTokens.Spacing.sm)
            }
        }
        .task {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                tintPulse = 1
            }
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                curtainSway = 5
            }
            startShaking()

            try? await Task.sleep(for: .milliseconds(350))
            withAnimation(.easeIn(duration: 1.05)) {
                shelfFallen = true
            }
            withAnimation(.easeIn(duration: 0.9).delay(0.15)) {
                booksFalling = true
            }
            try? await Task.sleep(for: .milliseconds(450))
            withAnimation(.easeOut(duration: 0.9)) {
                glassShatter = true
                wallCracked = true
            }

            try? await Task.sleep(for: .milliseconds(1400))
            withAnimation(.easeIn(duration: 0.7)) {
                buttonVisible = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("The bookshelf falls onto the table, protecting the person crouched underneath. The window shatters and cracks spread across the wall.")
    }

    private func startShaking() {
        Task {
            for _ in 0..<28 {
                let dx = CGFloat.random(in: -9...9)
                let dy = CGFloat.random(in: -6...6)
                withAnimation(.linear(duration: 0.09)) {
                    shakeOffset = CGSize(width: dx, height: dy)
                }
                try? await Task.sleep(for: .milliseconds(100))
            }
            withAnimation(.easeOut(duration: 0.5)) {
                shakeOffset = .zero
            }
        }
    }

    private var stage: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .fill(DesignTokens.Palette.calmSurface)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 14, y: 6)

                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                        .fill(Color(red: 0.90, green: 0.82, blue: 0.74))
                        .frame(height: h * 0.18)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .padding(DesignTokens.Spacing.xs)

                    if wallCracked {
                        WallCrackShape()
                            .stroke(
                                DesignTokens.Palette.softInk.opacity(0.55),
                                style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round)
                            )
                            .frame(width: w * 0.55, height: h * 0.42)
                            .position(x: w * 0.55, y: h * 0.20)
                            .transition(.opacity)
                    }

                    ShatteringWindow(sway: curtainSway, shatter: glassShatter)
                        .frame(width: w * 0.36, height: h * 0.36)
                        .position(x: w * 0.28, y: h * 0.30)

                    if glassShatter {
                        ForEach(0..<7, id: \.self) { index in
                            GlassShardShape()
                                .fill(Color(red: 0.72, green: 0.85, blue: 0.92).opacity(0.85))
                                .frame(width: w * 0.035, height: w * 0.05)
                                .rotationEffect(.degrees(Double(index) * 41 - 20))
                                .position(
                                    x: w * (0.12 + Double(index) * 0.06),
                                    y: h * (0.88 + Double(index % 2) * 0.02)
                                )
                                .shadow(color: DesignTokens.Palette.softShadow, radius: 1, y: 1)
                                .transition(.opacity.combined(with: .scale))
                        }
                    }

                    QuakeRoomTable()
                        .frame(width: w * 0.30, height: h * 0.22)
                        .position(x: w * 0.44, y: h * 0.78)

                    QuakeRoomChair()
                        .frame(width: w * 0.10, height: h * 0.22)
                        .rotationEffect(.degrees(shelfFallen ? 14 : 0), anchor: .bottom)
                        .position(x: w * 0.64, y: h * 0.76)

                    TuckedPerson()
                        .frame(width: w * 0.10, height: h * 0.18)
                        .position(x: w * 0.44, y: h * 0.85)

                    QuakeBookshelf()
                        .frame(width: w * 0.22, height: h * 0.58)
                        .rotationEffect(.degrees(shelfFallen ? -42 : 3), anchor: .bottomTrailing)
                        .position(x: w * 0.82, y: h * 0.51)

                    ForEach(0..<5, id: \.self) { index in
                        fallingBook(index: index, width: w, height: h)
                    }

                    QuakeLamp()
                        .frame(width: w * 0.09, height: h * 0.13)
                        .rotationEffect(.degrees(shelfFallen ? 72 : 0))
                        .position(
                            x: shelfFallen ? w * 0.22 : w * 0.28,
                            y: shelfFallen ? h * 0.92 : h * 0.90
                        )

                    QuakeClock()
                        .frame(width: w * 0.11, height: h * 0.11)
                        .rotationEffect(.degrees(shelfFallen ? -48 : 0))
                        .position(
                            x: shelfFallen ? w * 0.46 : w * 0.52,
                            y: shelfFallen ? h * 0.93 : h * 0.91
                        )
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
            }
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
    }

    private func fallingBook(index: Int, width w: CGFloat, height h: CGFloat) -> some View {
        let startX = w * (0.74 + CGFloat(index) * 0.03)
        let startY = h * (0.26 + CGFloat(index) * 0.06)
        let endX = w * (0.34 + CGFloat(index) * 0.06)
        let endY = h * (0.86 + CGFloat(index % 2) * 0.02)
        let rotation = Double(index) * 47 - 60
        return RoundedRectangle(cornerRadius: 2)
            .fill(bookColor(for: index))
            .frame(width: w * 0.04, height: w * 0.024)
            .rotationEffect(.degrees(booksFalling ? rotation : 0))
            .position(
                x: booksFalling ? endX : startX,
                y: booksFalling ? endY : startY
            )
            .opacity(booksFalling ? 1 : 0)
            .animation(
                .easeIn(duration: 0.85).delay(Double(index) * 0.08),
                value: booksFalling
            )
    }

    private func bookColor(for index: Int) -> Color {
        let palette: [Color] = [
            Color(red: 0.72, green: 0.32, blue: 0.28),
            Color(red: 0.85, green: 0.72, blue: 0.42),
            Color(red: 0.36, green: 0.55, blue: 0.71),
            Color(red: 0.42, green: 0.60, blue: 0.44),
            Color(red: 0.62, green: 0.48, blue: 0.36)
        ]
        return palette[index % palette.count]
    }
}

private struct TuckedPerson: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.55, height: h * 0.70)
                    .position(x: w * 0.30, y: h * 0.45)

                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.30, y: h * 0.00001)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.30)
                    .rotationEffect(.degrees(-25))
                    .position(x: w * 1.25, y: h * 0.55)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(90))
                    .position(x: w * 0.58, y: h * 0.32)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.30)
                    .rotationEffect(.degrees(25))
                    .position(x: w * 0.75, y: h * 0.55)
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
    }
}

private struct ShatteringWindow: View {
    var sway: Double
    var shatter: Bool

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

                ShatterCrackShape()
                    .trim(from: 0, to: shatter ? 1 : 0.25)
                    .stroke(
                        DesignTokens.Palette.softInk.opacity(shatter ? 0.85 : 0.5),
                        style: StrokeStyle(lineWidth: shatter ? 1.8 : 1.4, lineCap: .round, lineJoin: .round)
                    )
                    .padding(6)

                if shatter {
                    ForEach(0..<5, id: \.self) { index in
                        GlassShardShape()
                            .fill(Color(red: 0.62, green: 0.78, blue: 0.88).opacity(0.9))
                            .frame(width: w * 0.09, height: w * 0.14)
                            .rotationEffect(.degrees(Double(index) * 55 - 20))
                            .position(
                                x: w * (0.30 + Double(index) * 0.12),
                                y: h * (0.55 + Double(index % 2) * 0.12)
                            )
                            .transition(.opacity.combined(with: .scale))
                    }
                }

                HStack(spacing: 0) {
                    QuakeCurtainShape()
                        .fill(Color(red: 0.94, green: 0.85, blue: 0.76))
                        .frame(width: w * 0.32)
                        .rotationEffect(.degrees(sway), anchor: .top)
                    Spacer()
                    QuakeCurtainShape()
                        .fill(Color(red: 0.94, green: 0.85, blue: 0.76))
                        .frame(width: w * 0.32)
                        .scaleEffect(x: -1, anchor: .center)
                        .rotationEffect(.degrees(-sway), anchor: .top)
                }
                .frame(width: w, height: h)
                .padding(4)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            }
        }
    }
}

private struct QuakeCurtainShape: Shape {
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

private struct ShatterCrackShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let center = CGPoint(x: rect.midX + rect.width * 0.05, y: rect.midY - rect.height * 0.02)

        p.move(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.18))
        p.addLine(to: center)
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.maxY - rect.height * 0.14))

        p.move(to: center)
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.maxY - rect.height * 0.08))

        p.move(to: center)
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.06, y: rect.minY + rect.height * 0.10))

        p.move(to: center)
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.18, y: rect.midY + rect.height * 0.06))

        p.move(to: center)
        p.addLine(to: CGPoint(x: rect.midX + rect.width * 0.30, y: rect.maxY - rect.height * 0.22))
        return p
    }
}

private struct WallCrackShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let top = CGPoint(x: rect.midX - rect.width * 0.10, y: rect.minY)

        p.move(to: top)
        p.addLine(to: CGPoint(x: rect.midX - rect.width * 0.02, y: rect.minY + rect.height * 0.22))
        p.addLine(to: CGPoint(x: rect.midX - rect.width * 0.18, y: rect.minY + rect.height * 0.42))
        p.addLine(to: CGPoint(x: rect.midX + rect.width * 0.04, y: rect.minY + rect.height * 0.62))
        p.addLine(to: CGPoint(x: rect.midX - rect.width * 0.10, y: rect.maxY))

        p.move(to: CGPoint(x: rect.midX - rect.width * 0.02, y: rect.minY + rect.height * 0.22))
        p.addLine(to: CGPoint(x: rect.midX + rect.width * 0.24, y: rect.minY + rect.height * 0.35))
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.02, y: rect.minY + rect.height * 0.30))

        p.move(to: CGPoint(x: rect.midX - rect.width * 0.18, y: rect.minY + rect.height * 0.42))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.08, y: rect.minY + rect.height * 0.55))

        p.move(to: CGPoint(x: rect.midX + rect.width * 0.04, y: rect.minY + rect.height * 0.62))
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.minY + rect.height * 0.78))
        return p
    }
}

private struct GlassShardShape: Shape {
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

private struct QuakeBookshelf: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.72, green: 0.58, blue: 0.45))
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 6, y: 3)

                VStack(spacing: h * 0.22) {
                    ForEach(0..<3, id: \.self) { _ in
                        Capsule()
                            .fill(Color(red: 0.55, green: 0.42, blue: 0.32))
                            .frame(height: 3)
                            .padding(.horizontal, w * 0.1)
                    }
                }
                .padding(.top, h * 0.12)
            }
        }
    }
}

private struct QuakeRoomTable: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.80, green: 0.66, blue: 0.52))
                    .frame(height: h * 0.32)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)

                HStack {
                    Capsule()
                        .fill(Color(red: 0.62, green: 0.48, blue: 0.36))
                        .frame(width: w * 0.06, height: h * 0.68)
                    Spacer()
                    Capsule()
                        .fill(Color(red: 0.62, green: 0.48, blue: 0.36))
                        .frame(width: w * 0.06, height: h * 0.68)
                }
                .padding(.horizontal, w * 0.08)
                .padding(.top, h * 0.30)
            }
        }
    }
}

private struct QuakeRoomChair: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.68, green: 0.72, blue: 0.78))
                    .frame(width: w * 0.28, height: h * 0.55)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .fill(Color(red: 0.72, green: 0.76, blue: 0.82))
                        .frame(height: h * 0.16)
                        .padding(.horizontal, w * 0.05)

                    HStack {
                        Capsule()
                            .fill(Color(red: 0.50, green: 0.55, blue: 0.62))
                            .frame(width: w * 0.10, height: h * 0.35)
                        Spacer()
                        Capsule()
                            .fill(Color(red: 0.50, green: 0.55, blue: 0.62))
                            .frame(width: w * 0.10, height: h * 0.35)
                    }
                    .padding(.horizontal, w * 0.08)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

private struct QuakeLamp: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            VStack(spacing: 0) {
                QuakeTrapezoidShape()
                    .fill(Color(red: 0.95, green: 0.82, blue: 0.55))
                    .frame(width: w * 0.90, height: h * 0.45)
                Rectangle()
                    .fill(Color(red: 0.55, green: 0.42, blue: 0.32))
                    .frame(width: w * 0.10, height: h * 0.38)
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.42, green: 0.32, blue: 0.24))
                    .frame(width: w * 0.60, height: h * 0.12)
            }
            .frame(width: w, height: h)
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }
}

private struct QuakeTrapezoidShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let inset = rect.width * 0.20
        p.move(to: CGPoint(x: rect.minX + inset, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct QuakeClock: View {
    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            ZStack {
                Circle()
                    .fill(Color(red: 0.62, green: 0.48, blue: 0.36))
                    .frame(width: side, height: side)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.96, green: 0.94, blue: 0.90),
                                Color(red: 0.90, green: 0.87, blue: 0.82)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: side * 0.78, height: side * 0.78)

                ForEach(0..<12, id: \.self) { tick in
                    Capsule()
                        .fill(DesignTokens.Palette.softInk.opacity(0.55))
                        .frame(width: 1.5, height: side * 0.06)
                        .offset(y: -side * 0.34)
                        .rotationEffect(.degrees(Double(tick) * 30))
                }

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: 2.2, height: side * 0.28)
                    .offset(y: -side * 0.10)
                    .rotationEffect(.degrees(40))

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: 1.8, height: side * 0.36)
                    .offset(y: -side * 0.14)
                    .rotationEffect(.degrees(-20))

                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: side * 0.08, height: side * 0.08)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }
}

#Preview {
    AftershockView(onContinue: {})
}
