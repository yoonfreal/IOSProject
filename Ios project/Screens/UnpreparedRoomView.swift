import SwiftUI

struct UnpreparedRoomView: View {
    var onContinue: () -> Void

    @State private var chaosRevealed = false
    @State private var curtainSway: Double = -2.6
    @State private var alertPulse = false

    var body: some View {
        ZStack {
            DesignTokens.Palette.urgencyBackground.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("If you hadn't prepped…")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                    Text("Loose objects fall. Glass shatters. People get hurt.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                }

                GeometryReader { proxy in
                    let w = proxy.size.width
                    let h = proxy.size.height
                    let floorHeight = h * 0.18

                    ZStack {
                        RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                            .fill(DesignTokens.Palette.calmSurface)
                            .shadow(color: DesignTokens.Palette.softShadow, radius: 14, y: 6)

                        ZStack {
                            RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                                .fill(Color(red: 0.92, green: 0.88, blue: 0.83))
                                .frame(height: floorHeight)
                                .frame(maxHeight: .infinity, alignment: .bottom)
                                .padding(DesignTokens.Spacing.xs)

                            RoomWindow(sway: curtainSway, cracked: chaosRevealed)
                                .frame(width: w * 0.36, height: h * 0.36)
                                .position(x: w * 0.28, y: h * 0.30)

                            Bookshelf()
                                .frame(width: w * 0.22, height: h * 0.58)
                                .rotationEffect(.degrees(chaosRevealed ? -7 : 0), anchor: .bottomLeading)
                                .position(x: w * 0.82, y: h * 0.51)

                            RoomTable()
                                .frame(width: w * 0.30, height: h * 0.22)
                                .position(x: w * 0.44, y: h * 0.78)

                            RoomChair()
                                .frame(width: w * 0.10, height: h * 0.22)
                                .rotationEffect(.degrees(chaosRevealed ? 18 : 0), anchor: .bottom)
                                .position(x: w * 0.64, y: h * 0.76)

                            BooksStackShape()
                                .frame(width: w * 0.16, height: h * 0.06)
                                .rotationEffect(.degrees(chaosRevealed ? -28 : 0))
                                .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                                .position(
                                    x: chaosRevealed ? w * 0.72 : w * 0.82,
                                    y: chaosRevealed ? h * 0.92 : h * 0.34
                                )

                            LampShape()
                                .frame(width: w * 0.09, height: h * 0.13)
                                .rotationEffect(.degrees(chaosRevealed ? -80 : 0))
                                .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                                .position(
                                    x: chaosRevealed ? w * 0.34 : w * 0.42,
                                    y: chaosRevealed ? h * 0.92 : h * 0.62
                                )

                            ClockShape()
                                .frame(width: w * 0.11, height: h * 0.11)
                                .rotationEffect(.degrees(chaosRevealed ? 55 : 0))
                                .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                                .position(
                                    x: chaosRevealed ? w * 0.19 : w * 0.56,
                                    y: chaosRevealed ? h * 0.92 : h * 0.12
                                )

                            ForEach(0..<4, id: \.self) { index in
                                GlassShardShape()
                                    .fill(Color(red: 0.72, green: 0.85, blue: 0.92).opacity(0.85))
                                    .frame(width: w * 0.035, height: w * 0.05)
                                    .rotationEffect(.degrees(Double(index) * 37 - 15))
                                    .position(
                                        x: w * (0.15 + Double(index) * 0.045),
                                        y: h * (0.88 + Double(index % 2) * 0.02)
                                    )
                                    .opacity(chaosRevealed ? 0.9 : 0)
                            }

                            PersonFigure(injured: chaosRevealed)
                                .frame(width: w * 0.11, height: h * 0.30)
                                .rotationEffect(.degrees(chaosRevealed ? -80 : 0), anchor: .bottom)
                                .position(
                                    x: chaosRevealed ? w * 0.48 : w * 0.16,
                                    y: chaosRevealed ? h * 0.82 : h * 0.70
                                )

                            if chaosRevealed {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                                    .opacity(alertPulse ? 1 : 0.35)
                                    .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                                    .position(x: w * 0.54, y: h * 0.68)
                                    .accessibilityHidden(true)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
                    }
                }
                .aspectRatio(3.0 / 4.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle())
                    .accessibilityLabel("Continue past the unprepared-room outcome")

                Spacer(minLength: DesignTokens.Spacing.sm)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.9).delay(0.2)) {
                chaosRevealed = true
            }
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                curtainSway = 2.6
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true).delay(1.0)) {
                alertPulse = true
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Unprepared room. Books, lamp, and clock have fallen. The window is cracked. A person lies on the floor near broken glass.")
    }
}

private struct BooksStackShape: View {
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
    }

    private func bookSpine(color: Color, widthRatio: CGFloat, heightRatio: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: w * widthRatio, height: h * heightRatio)
    }
}

private struct LampShape: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            VStack(spacing: 0) {
                TrapezoidShape()
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
    }
}

private struct TrapezoidShape: Shape {
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

private struct ClockShape: View {
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
    }
}

private struct Bookshelf: View {
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

                VStack {
                    Spacer()
                    HStack(spacing: w * 0.06) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.55, green: 0.62, blue: 0.72))
                            .frame(width: w * 0.16, height: h * 0.09)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color(red: 0.78, green: 0.60, blue: 0.42))
                            .frame(width: w * 0.14, height: h * 0.08)
                    }
                    .padding(.bottom, h * 0.20)
                    .padding(.horizontal, w * 0.10)
                }
            }
        }
    }
}

private struct RoomWindow: View {
    var sway: Double
    var cracked: Bool

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(red: 0.84, green: 0.92, blue: 0.98))
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(DesignTokens.Palette.softInk.opacity(0.18), lineWidth: 2)

                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.14))
                    .frame(width: 2)
                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.14))
                    .frame(height: 2)

                if cracked {
                    WindowCrackShape()
                        .stroke(DesignTokens.Palette.softInk.opacity(0.75), style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round))
                        .padding(6)
                        .transition(.opacity)
                }

                HStack(spacing: 0) {
                    CurtainShape()
                        .fill(Color(red: 0.94, green: 0.85, blue: 0.76))
                        .frame(width: w * 0.32)
                        .rotationEffect(.degrees(sway), anchor: .top)
                    Spacer()
                    CurtainShape()
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

private struct WindowCrackShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let cx = rect.midX
        let cy = rect.midY
        let center = CGPoint(x: cx + rect.width * 0.05, y: cy - rect.height * 0.02)

        p.move(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.minY + rect.height * 0.18))
        p.addLine(to: CGPoint(x: cx - rect.width * 0.10, y: cy - rect.height * 0.14))
        p.addLine(to: center)
        p.addLine(to: CGPoint(x: cx + rect.width * 0.20, y: cy + rect.height * 0.10))
        p.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.08, y: rect.maxY - rect.height * 0.16))

        p.move(to: center)
        p.addLine(to: CGPoint(x: cx - rect.width * 0.22, y: cy + rect.height * 0.24))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.14, y: rect.maxY - rect.height * 0.08))

        p.move(to: center)
        p.addLine(to: CGPoint(x: cx + rect.width * 0.28, y: cy - rect.height * 0.24))

        p.move(to: CGPoint(x: cx - rect.width * 0.10, y: cy - rect.height * 0.14))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.08, y: cy + rect.height * 0.06))

        return p
    }
}

private struct CurtainShape: Shape {
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

private struct RoomTable: View {
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

private struct RoomChair: View {
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

private struct PersonFigure: View {
    var injured: Bool

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
                    .frame(width: w * 0.55, height: h * 0.4)
                    .position(x: w * 0.5, y: h * 0.4)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.42, y: h * 0.72)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.58, y: h * 0.72)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(injured ? 40 : 12), anchor: .top)
                    .position(x: w * 0.30, y: h * 0.34)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(injured ? -40 : -12), anchor: .top)
                    .position(x: w * 0.70, y: h * 0.34)

                if injured {
                    Circle()
                        .fill(DesignTokens.Palette.urgencyDeep)
                        .frame(width: w * 0.16, height: w * 0.16)
                        .opacity(0.75)
                        .position(x: w * 0.68, y: h * 0.10)
                }
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
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

#Preview {
    UnpreparedRoomView(onContinue: {})
}
