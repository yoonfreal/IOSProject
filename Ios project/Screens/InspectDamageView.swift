import SwiftUI

struct InspectDamageView: View {
    var onContinue: () -> Void

    @State private var currentScale: CGFloat = 1.0
    @State private var baseScale: CGFloat = 1.0
    @State private var hintVisible = true
    @State private var hasInteracted = false

    private let minScale: CGFloat = 1.0
    private let maxScale: CGFloat = 2.5
    private let advanceThreshold: CGFloat = 1.5

    var body: some View {
        ZStack {
            DesignTokens.Palette.calmBackground.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("Inspect the damage")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                    Text("Pinch to zoom in and check the cracks.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                        .fill(DesignTokens.Palette.calmSurface)
                        .shadow(color: DesignTokens.Palette.softShadow, radius: 14, y: 6)

                    DamagedRoom()
                        .padding(DesignTokens.Spacing.md)
                        .scaleEffect(currentScale)
                        .animation(DesignTokens.Motion.spring, value: currentScale)

                    if hintVisible {
                        Text("pinch to inspect")
                            .font(DesignTokens.FontScale.caption)
                            .foregroundStyle(DesignTokens.Palette.mutedInk)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Capsule().fill(DesignTokens.Palette.calmSurface.opacity(0.9)))
                            .shadow(color: DesignTokens.Palette.softShadow, radius: 6, y: 2)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, DesignTokens.Spacing.md)
                            .transition(.opacity)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
                .aspectRatio(3.0 / 4.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)
                .gesture(magnification)
                .accessibilityLabel("Damaged room with cracked walls, toppled bookshelf, and broken lamp. Pinch to zoom.")

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!hasInteracted)
                    .opacity(hasInteracted ? 1 : 0.4)
                    .animation(DesignTokens.Motion.easeGentle, value: hasInteracted)
                    .accessibilityLabel(hasInteracted ? "Continue to the next screen" : "Pinch the image first to continue")

                Spacer(minLength: DesignTokens.Spacing.sm)
            }
        }
    }

    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                if hintVisible {
                    withAnimation(DesignTokens.Motion.quick) {
                        hintVisible = false
                    }
                }
                let raw = baseScale * value
                currentScale = min(max(raw, minScale), maxScale)
                if currentScale >= advanceThreshold {
                    hasInteracted = true
                }
            }
            .onEnded { _ in
                baseScale = currentScale
            }
    }
}

private struct DamagedRoom: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height

            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(red: 0.93, green: 0.90, blue: 0.85))

                WallCrackMain()
                    .stroke(DesignTokens.Palette.softInk.opacity(0.75), style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))

                WallCrackBranches()
                    .stroke(DesignTokens.Palette.softInk.opacity(0.5), style: StrokeStyle(lineWidth: 1.4, lineCap: .round, lineJoin: .round))

                WallCrackSecondary()
                    .stroke(DesignTokens.Palette.softInk.opacity(0.45), style: StrokeStyle(lineWidth: 1.2, lineCap: .round, lineJoin: .round))

                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.86, green: 0.78, blue: 0.70))
                    .frame(height: h * 0.18)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(DesignTokens.Spacing.xs)

                DamagedWindow()
                    .frame(width: w * 0.36, height: h * 0.36)
                    .position(x: w * 0.28, y: h * 0.30)

                DamagedTable()
                    .frame(width: w * 0.30, height: h * 0.22)
                    .position(x: w * 0.44, y: h * 0.78)

                DamagedChair()
                    .frame(width: w * 0.14, height: h * 0.18)
                    .rotationEffect(.degrees(-72), anchor: .bottomLeading)
                    .position(x: w * 0.66, y: h * 0.80)

                DamagedPersonFigure()
                    .frame(width: w * 0.10, height: h * 0.28)
                    .position(x: w * 0.13, y: h * 0.68)

                DamagedBookshelf()
                    .frame(width: w * 0.22, height: h * 0.58)
                    .rotationEffect(.degrees(78), anchor: .bottomTrailing)
                    .position(x: w * 0.82, y: h * 0.51)

                DamagedBooksStack()
                    .frame(width: w * 0.20, height: h * 0.05)
                    .position(x: w * 0.72, y: h * 0.92)

                DamagedLamp()
                    .frame(width: w * 0.13, height: h * 0.09)
                    .rotationEffect(.degrees(-58))
                    .position(x: w * 0.28, y: h * 0.93)

                DamagedClock()
                    .frame(width: w * 0.11, height: h * 0.11)
                    .position(x: w * 0.52, y: h * 0.91)

                DebrisDots()
            }
            .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
        }
    }
}

private struct WallCrackMain: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.42, y: 0))
        p.addLine(to: CGPoint(x: rect.width * 0.36, y: rect.height * 0.15))
        p.addLine(to: CGPoint(x: rect.width * 0.48, y: rect.height * 0.28))
        p.addLine(to: CGPoint(x: rect.width * 0.40, y: rect.height * 0.42))
        p.addLine(to: CGPoint(x: rect.width * 0.52, y: rect.height * 0.55))
        p.addLine(to: CGPoint(x: rect.width * 0.44, y: rect.height * 0.68))
        return p
    }
}

private struct WallCrackBranches: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.36, y: rect.height * 0.15))
        p.addLine(to: CGPoint(x: rect.width * 0.22, y: rect.height * 0.08))

        p.move(to: CGPoint(x: rect.width * 0.48, y: rect.height * 0.28))
        p.addLine(to: CGPoint(x: rect.width * 0.62, y: rect.height * 0.22))

        p.move(to: CGPoint(x: rect.width * 0.40, y: rect.height * 0.42))
        p.addLine(to: CGPoint(x: rect.width * 0.28, y: rect.height * 0.50))

        p.move(to: CGPoint(x: rect.width * 0.52, y: rect.height * 0.55))
        p.addLine(to: CGPoint(x: rect.width * 0.66, y: rect.height * 0.60))
        return p
    }
}

private struct WallCrackSecondary: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.width * 0.75, y: 0))
        p.addLine(to: CGPoint(x: rect.width * 0.70, y: rect.height * 0.10))
        p.addLine(to: CGPoint(x: rect.width * 0.80, y: rect.height * 0.22))
        p.addLine(to: CGPoint(x: rect.width * 0.72, y: rect.height * 0.34))

        p.move(to: CGPoint(x: rect.width * 0.08, y: rect.height * 0.05))
        p.addLine(to: CGPoint(x: rect.width * 0.14, y: rect.height * 0.18))
        p.addLine(to: CGPoint(x: rect.width * 0.06, y: rect.height * 0.30))
        return p
    }
}

private struct DebrisDots: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(DesignTokens.Palette.softInk.opacity(0.35))
                        .frame(width: CGFloat(2 + i % 3), height: CGFloat(2 + i % 3))
                        .position(
                            x: w * (0.18 + CGFloat(i) * 0.09),
                            y: h * (0.94 - CGFloat(i % 2) * 0.03)
                        )
                }
            }
        }
    }
}

private struct DamagedWindow: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(red: 0.82, green: 0.89, blue: 0.94))
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .stroke(DesignTokens.Palette.softInk.opacity(0.22), lineWidth: 2)

                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.12))
                    .frame(width: 2)
                Rectangle()
                    .fill(DesignTokens.Palette.softInk.opacity(0.12))
                    .frame(height: 2)

                WindowShatter()
                    .stroke(DesignTokens.Palette.softInk.opacity(0.7), lineWidth: 1.4)
                    .padding(6)

                HStack(spacing: 0) {
                    DamagedCurtainShape()
                        .fill(Color(red: 0.90, green: 0.80, blue: 0.70))
                        .frame(width: w * 0.30)
                        .rotationEffect(.degrees(-8), anchor: .top)
                    Spacer()
                    DamagedCurtainShape()
                        .fill(Color(red: 0.90, green: 0.80, blue: 0.70))
                        .frame(width: w * 0.30)
                        .scaleEffect(x: -1, anchor: .center)
                        .rotationEffect(.degrees(6), anchor: .top)
                }
                .frame(width: w, height: h)
                .padding(4)
                .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.md))
            }
        }
    }
}

private struct DamagedCurtainShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 0))
        p.addLine(to: CGPoint(x: rect.maxX, y: 0))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX * 0.60, y: rect.maxY),
            control: CGPoint(x: rect.maxX * 1.30, y: rect.maxY * 0.60)
        )
        p.addLine(to: CGPoint(x: 0, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

private struct WindowShatter: Shape {
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

        p.move(to: CGPoint(x: rect.midX * 1.1, y: rect.midY * 1.15))
        p.addLine(to: CGPoint(x: rect.maxX * 0.95, y: rect.maxY * 0.45))

        p.move(to: CGPoint(x: rect.midX * 0.9, y: rect.midY * 0.9))
        p.addLine(to: CGPoint(x: rect.minX + rect.width * 0.10, y: rect.height * 0.55))
        return p
    }
}

private struct DamagedBookshelf: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.70, green: 0.56, blue: 0.43))
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 6, y: 3)

                VStack(spacing: h * 0.22) {
                    ForEach(0..<3, id: \.self) { _ in
                        Capsule()
                            .fill(Color(red: 0.52, green: 0.40, blue: 0.30))
                            .frame(height: 3)
                            .padding(.horizontal, w * 0.1)
                    }
                }
                .padding(.top, h * 0.12)
            }
        }
    }
}

private struct DamagedTable: View {
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

private struct DamagedChair: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.66, green: 0.70, blue: 0.76))
                    .frame(width: w * 0.30, height: h * 0.55)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                        .fill(Color(red: 0.70, green: 0.74, blue: 0.80))
                        .frame(height: h * 0.16)
                        .padding(.horizontal, w * 0.05)

                    HStack {
                        Capsule()
                            .fill(Color(red: 0.48, green: 0.53, blue: 0.60))
                            .frame(width: w * 0.10, height: h * 0.35)
                        Spacer()
                        Capsule()
                            .fill(Color(red: 0.48, green: 0.53, blue: 0.60))
                            .frame(width: w * 0.10, height: h * 0.35)
                    }
                    .padding(.horizontal, w * 0.08)
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}

private struct DamagedPersonFigure: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.5, y: h * 0.20)

                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.55, height: h * 0.36)
                    .position(x: w * 0.5, y: h * 0.48)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.26)
                    .position(x: w * 0.42, y: h * 0.78)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.26)
                    .position(x: w * 0.58, y: h * 0.78)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(28), anchor: .top)
                    .position(x: w * 0.30, y: h * 0.42)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.26)
                    .rotationEffect(.degrees(-28), anchor: .top)
                    .position(x: w * 0.70, y: h * 0.42)
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
    }
}

private struct DamagedBooksStack: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                bookSpine(color: Color(red: 0.72, green: 0.32, blue: 0.28), widthRatio: 0.18, heightRatio: 0.9, w: w, h: h)
                    .rotationEffect(.degrees(-18))
                    .position(x: w * 0.15, y: h * 0.6)
                bookSpine(color: Color(red: 0.85, green: 0.72, blue: 0.42), widthRatio: 0.16, heightRatio: 0.75, w: w, h: h)
                    .rotationEffect(.degrees(12))
                    .position(x: w * 0.34, y: h * 0.7)
                bookSpine(color: Color(red: 0.36, green: 0.55, blue: 0.71), widthRatio: 0.20, heightRatio: 0.85, w: w, h: h)
                    .rotationEffect(.degrees(-6))
                    .position(x: w * 0.55, y: h * 0.55)
                bookSpine(color: Color(red: 0.42, green: 0.60, blue: 0.44), widthRatio: 0.14, heightRatio: 0.80, w: w, h: h)
                    .rotationEffect(.degrees(24))
                    .position(x: w * 0.74, y: h * 0.7)
                bookSpine(color: Color(red: 0.62, green: 0.48, blue: 0.36), widthRatio: 0.18, heightRatio: 0.72, w: w, h: h)
                    .rotationEffect(.degrees(-30))
                    .position(x: w * 0.90, y: h * 0.6)
            }
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }

    private func bookSpine(color: Color, widthRatio: CGFloat, heightRatio: CGFloat, w: CGFloat, h: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(color)
            .frame(width: w * widthRatio, height: h * heightRatio)
    }
}

private struct DamagedLamp: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            HStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.42, green: 0.32, blue: 0.24))
                    .frame(width: w * 0.20, height: h * 0.55)
                Rectangle()
                    .fill(Color(red: 0.55, green: 0.42, blue: 0.32))
                    .frame(width: w * 0.42, height: h * 0.22)
                DamagedTrapezoidShape()
                    .fill(Color(red: 0.90, green: 0.78, blue: 0.52))
                    .frame(width: w * 0.38, height: h * 0.85)
            }
            .frame(width: w, height: h, alignment: .center)
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }
}

private struct DamagedTrapezoidShape: Shape {
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

private struct DamagedClock: View {
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
                                Color(red: 0.94, green: 0.92, blue: 0.88),
                                Color(red: 0.86, green: 0.83, blue: 0.78)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: side * 0.78, height: side * 0.78)

                ForEach(0..<12, id: \.self) { tick in
                    Capsule()
                        .fill(DesignTokens.Palette.softInk.opacity(0.45))
                        .frame(width: 1.5, height: side * 0.06)
                        .offset(y: -side * 0.34)
                        .rotationEffect(.degrees(Double(tick) * 30))
                }

                Capsule()
                    .fill(DesignTokens.Palette.softInk.opacity(0.85))
                    .frame(width: 2.2, height: side * 0.26)
                    .offset(y: -side * 0.08)
                    .rotationEffect(.degrees(110))

                Capsule()
                    .fill(DesignTokens.Palette.softInk.opacity(0.85))
                    .frame(width: 1.8, height: side * 0.34)
                    .offset(y: -side * 0.12)
                    .rotationEffect(.degrees(155))

                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: side * 0.08, height: side * 0.08)

                Path { p in
                    p.move(to: CGPoint(x: side * 0.20, y: side * 0.22))
                    p.addLine(to: CGPoint(x: side * 0.55, y: side * 0.55))
                    p.addLine(to: CGPoint(x: side * 0.42, y: side * 0.82))
                    p.move(to: CGPoint(x: side * 0.55, y: side * 0.55))
                    p.addLine(to: CGPoint(x: side * 0.82, y: side * 0.42))
                    p.move(to: CGPoint(x: side * 0.55, y: side * 0.55))
                    p.addLine(to: CGPoint(x: side * 0.28, y: side * 0.72))
                }
                .stroke(DesignTokens.Palette.softInk.opacity(0.7), lineWidth: 1.1)
                .frame(width: side, height: side)
            }
            .rotationEffect(.degrees(-14))
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
    }
}

#Preview {
    InspectDamageView(onContinue: {})
}
