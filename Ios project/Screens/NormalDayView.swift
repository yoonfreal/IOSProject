import SwiftUI

struct NormalDayView: View {
    var onStart: () -> Void

    @State private var buttonVisible = false
    @State private var curtainSway: Double = -2.6

    var body: some View {
        ZStack {
            DesignTokens.Palette.calmBackground.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.lg) {
                Spacer(minLength: DesignTokens.Spacing.md)

                RoomScene(curtainSway: curtainSway)
                    .padding(.horizontal, DesignTokens.Spacing.md)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("A normal day")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                    Text("Everything looks fine — until it isn't.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)

                Button("Tap to start", action: onStart)
                    .buttonStyle(PrimaryButtonStyle())
                    .opacity(buttonVisible ? 1 : 0)
                    .disabled(!buttonVisible)
                    .accessibilityLabel("Start the earthquake safety experience")

                Spacer(minLength: DesignTokens.Spacing.md)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true)) {
                curtainSway = 2.6
            }
        }
        .task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.easeIn(duration: 0.7)) {
                buttonVisible = true
            }
        }
    }
}

private struct RoomScene: View {
    var curtainSway: Double

    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            let floorHeight = h * 0.18

            ZStack {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                    .fill(DesignTokens.Palette.calmSurface)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 14, y: 6)

                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(Color(red: 0.92, green: 0.88, blue: 0.83))
                    .frame(height: floorHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(DesignTokens.Spacing.xs)

                RoomWindow(sway: curtainSway)
                    .frame(width: w * 0.36, height: h * 0.36)
                    .position(x: w * 0.28, y: h * 0.30)

                WallClock()
                    .frame(width: w * 0.13, height: w * 0.13)
                    .position(x: w * 0.56, y: h * 0.20)

                Bookshelf()
                    .frame(width: w * 0.22, height: h * 0.58)
                    .position(x: w * 0.82, y: h * 0.51)

                RoomTable()
                    .frame(width: w * 0.34, height: h * 0.22)
                    .position(x: w * 0.42, y: h * 0.78)

                RoomChair()
                    .frame(width: w * 0.12, height: h * 0.24)
                    .position(x: w * 0.68, y: h * 0.76)

                BooksStackShape()
                    .frame(width: w * 0.16, height: h * 0.06)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                    .position(x: w * 0.82, y: h * 0.34)

                LampShape()
                    .frame(width: w * 0.09, height: h * 0.13)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 3, y: 2)
                    .position(x: w * 0.42, y: h * 0.62)

                PersonFigure()
                    .frame(width: w * 0.11, height: h * 0.30)
                    .position(x: w * 0.16, y: h * 0.70)
            }
        }
        .aspectRatio(3.0 / 4.0, contentMode: .fit)
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

private struct RoomWindow: View {
    var sway: Double

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

private struct WallClock: View {
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

private struct PersonFigure: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Circle()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.5, y: h * 0.22)

                Capsule()
                    .fill(DesignTokens.Palette.calmAccent)
                    .frame(width: w * 0.55, height: h * 0.4)
                    .position(x: w * 0.5, y: h * 0.5)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.39, y: h * 0.82)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.3)
                    .position(x: w * 0.60, y: h * 0.82)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(12), anchor: .top)
                    .position(x: w * 0.20, y: h * 0.44)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(-12), anchor: .top)
                    .position(x: w * 0.80, y: h * 0.44)
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
    }
}

#Preview {
    NormalDayView(onStart: {})
}
