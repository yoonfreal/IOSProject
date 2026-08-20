import SwiftUI

struct EarthquakeView: View {
    var onContinue: () -> Void

    @State private var shakeOffset: CGSize = .zero
    @State private var buttonVisible = false
    @State private var bookshelfTilted = false
    @State private var tintPulse: CGFloat = 0
    @State private var curtainSway: Double = -5

    var body: some View {
        ZStack {
            DesignTokens.Palette.urgencyBackground.ignoresSafeArea()

            DesignTokens.Palette.urgencyAccent
                .opacity(0.08 + 0.12 * tintPulse)
                .ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.lg) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("Earthquake!")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    Text("The ground is shaking. Stay calm.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)

                ShakingRoom(bookshelfTilted: bookshelfTilted, curtainSway: curtainSway)
                    .offset(shakeOffset)
                    .padding(.horizontal, DesignTokens.Spacing.md)

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle(tint: DesignTokens.Palette.urgencyAccent))
                    .opacity(buttonVisible ? 1 : 0)
                    .disabled(!buttonVisible)
                    .accessibilityLabel("Continue past the earthquake shaking")

                Spacer(minLength: DesignTokens.Spacing.md)
            }
        }
        .task {
            startShaking()
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                curtainSway = 5
            }
            withAnimation(.easeIn(duration: 0.6).delay(0.5)) {
                bookshelfTilted = true
            }
            try? await Task.sleep(for: .seconds(2.5))
            withAnimation(.easeIn(duration: 0.7)) {
                buttonVisible = true
            }
        }
    }

    private func startShaking() {
        withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
            tintPulse = 1
        }
        Task {
            for _ in 0..<60 {
                let dx = CGFloat.random(in: -7...7)
                let dy = CGFloat.random(in: -5...5)
                withAnimation(.linear(duration: 0.08)) {
                    shakeOffset = CGSize(width: dx, height: dy)
                }
                try? await Task.sleep(for: .milliseconds(90))
            }
            withAnimation(.easeOut(duration: 0.4)) {
                shakeOffset = .zero
            }
        }
    }
}

private struct ShakingRoom: View {
    var bookshelfTilted: Bool
    var curtainSway: Double

    var body: some View {
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

                    CrackedWindow(sway: curtainSway)
                        .frame(width: w * 0.36, height: h * 0.36)
                        .position(x: w * 0.28, y: h * 0.30)

                    QuakeRoomTable()
                        .frame(width: w * 0.30, height: h * 0.22)
                        .position(x: w * 0.44, y: h * 0.78)

                    QuakeRoomChair()
                        .frame(width: w * 0.10, height: h * 0.22)
                        .position(x: w * 0.64, y: h * 0.76)

                    QuakePersonFigure()
                        .frame(width: w * 0.10, height: h * 0.28)
                        .position(x: w * 0.13, y: h * 0.68)

                    QuakeBookshelf()
                        .frame(width: w * 0.22, height: h * 0.58)
                        .position(x: w * 0.82, y: h * 0.51)
                        .rotationEffect(.degrees(bookshelfTilted ? 3 : 0), anchor: .bottomTrailing)
                        .animation(.easeInOut(duration: 0.6), value: bookshelfTilted)

                    QuakeBooksStack()
                        .frame(width: w * 0.16, height: h * 0.06)
                        .position(x: w * 0.78, y: h * 0.91)

                    QuakeLamp()
                        .frame(width: w * 0.09, height: h * 0.13)
                        .position(x: w * 0.28, y: h * 0.90)

                    QuakeClock()
                        .frame(width: w * 0.11, height: h * 0.11)
                        .position(x: w * 0.52, y: h * 0.91)
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
            }
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
    }
}

private struct CrackedWindow: View {
    var sway: Double

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

                CrackShape()
                    .stroke(DesignTokens.Palette.softInk.opacity(0.55), lineWidth: 1.4)
                    .padding(6)

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

private struct CrackShape: Shape {
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

private struct QuakePersonFigure: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.5, y: h * 0.32)

                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.55, height: h * 0.4)
                    .position(x: w * 0.5, y: h * 0.6)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.39, y: h * 0.92)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.60, y: h * 0.92)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(12), anchor: .top)
                    .position(x: w * 0.20, y: h * 0.54)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(-12), anchor: .top)
                    .position(x: w * 0.80, y: h * 0.54)
            }

            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
    }
}

private struct QuakeBooksStack: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            HStack(spacing: w * 0.02) {
                bookSpine(color: Color(red: 0.72, green: 0.32, blue: 0.28), widthRatio: 0.18, heightRatio: 1.0, w: w, h: h)
                bookSpine(color: Color(red: 0.85, green: 0.72, blue: 0.42), widthRatio: 0.14, heightRatio: 0.88, w: w, h: h)
                bookSpine(color: Color(red: 0.36, green: 0.55, blue: 0.71), widthRatio: 0.20, heightRatio: 1.0, w: w, h: h)
                bookSpine(color: Color(red: 0.42, green: 0.60, blue: 0.44), widthRatio: 0.14, heightRatio: 0.94, w: w, h: h)
                bookSpine(color: Color(red: 0.62, green: 0.48, blue: 0.36), widthRatio: 0.18, heightRatio: 0.90, w: w, h: h)
            }
            .frame(width: w, height: h, alignment: .bottom)
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }

    private func bookSpine(color: Color, widthRatio: CGFloat, heightRatio: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: w * widthRatio, height: h * heightRatio)
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
    EarthquakeView(onContinue: {})
}
