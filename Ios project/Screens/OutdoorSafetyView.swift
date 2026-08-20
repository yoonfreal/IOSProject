import SwiftUI

struct OutdoorSafetyView: View {
    var onContinue: () -> Void

    @State private var sceneVisible = false
    @State private var personShifted = false
    @State private var warningsVisible = false
    @State private var buttonVisible = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    DesignTokens.Palette.calmBackground,
                    DesignTokens.Palette.calmSurface
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("If you're outdoors")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.urgencyDeep)
                        .multilineTextAlignment(.center)
                    Text("Move to an open area. Stay away from buildings, trees, and power lines. Don't run inside.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                }
                .opacity(sceneVisible ? 1 : 0)
                .offset(y: sceneVisible ? 0 : 8)

                GeometryReader { proxy in
                    outdoorScene(width: proxy.size.width, height: proxy.size.height)
                }
                .aspectRatio(4.0 / 3.0, contentMode: .fit)
                .padding(.horizontal, DesignTokens.Spacing.md)

                tipsList
                    .padding(.horizontal, DesignTokens.Spacing.lg)
                    .opacity(warningsVisible ? 1 : 0)
                    .offset(y: warningsVisible ? 0 : 8)

                Spacer(minLength: DesignTokens.Spacing.sm)

                Button("Continue", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle(tint: DesignTokens.Palette.calmAccent))
                    .opacity(buttonVisible ? 1 : 0)
                    .accessibilityLabel("Continue to safety summary")

                Spacer(minLength: DesignTokens.Spacing.md)
            }
        }
        .task {
            withAnimation(DesignTokens.Motion.easeGentle) {
                sceneVisible = true
            }
            try? await Task.sleep(for: .milliseconds(450))
            withAnimation(DesignTokens.Motion.spring) {
                personShifted = true
            }
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(DesignTokens.Motion.easeGentle) {
                warningsVisible = true
            }
            try? await Task.sleep(for: .milliseconds(400))
            withAnimation(DesignTokens.Motion.easeGentle) {
                buttonVisible = true
            }
        }
    }

    @ViewBuilder
    private func outdoorScene(width w: CGFloat, height h: CGFloat) -> some View {
        let groundY = h * 0.82

        ZStack {
            RoundedRectangle(cornerRadius: DesignTokens.Radius.lg)
                .fill(Color(red: 0.86, green: 0.93, blue: 0.98))
                .shadow(color: DesignTokens.Palette.softShadow, radius: 12, y: 5)

            Circle()
                .fill(Color(red: 1.0, green: 0.90, blue: 0.55))
                .frame(width: w * 0.14, height: w * 0.14)
                .position(x: w * 0.5, y: h * 0.20)

            Rectangle()
                .fill(Color(red: 0.72, green: 0.82, blue: 0.60))
                .frame(height: h - groundY)
                .frame(maxHeight: .infinity, alignment: .bottom)

            OutdoorBuilding()
                .frame(width: w * 0.22, height: h * 0.44)
                .position(x: w * 0.16, y: groundY - h * 0.22)

            OutdoorTree()
                .frame(width: w * 0.16, height: h * 0.42)
                .position(x: w * 0.82, y: groundY - h * 0.21)

            OutdoorPowerLine()
                .frame(width: w * 0.28, height: h * 0.48)
                .position(x: w * 0.36, y: groundY - h * 0.24)

            OutdoorWarningBadge()
                .frame(width: 28, height: 28)
                .position(x: w * 0.16, y: groundY - h * 0.46)
                .opacity(warningsVisible ? 1 : 0)
                .scaleEffect(warningsVisible ? 1 : 0.4)

            OutdoorWarningBadge()
                .frame(width: 28, height: 28)
                .position(x: w * 0.82, y: groundY - h * 0.44)
                .opacity(warningsVisible ? 1 : 0)
                .scaleEffect(warningsVisible ? 1 : 0.4)

            OutdoorWarningBadge()
                .frame(width: 28, height: 28)
                .position(x: w * 0.36, y: groundY - h * 0.50)
                .opacity(warningsVisible ? 1 : 0)
                .scaleEffect(warningsVisible ? 1 : 0.4)

            OutdoorStandingPerson()
                .frame(width: w * 0.10, height: h * 0.28)
                .position(
                    x: personShifted ? w * 0.60 : w * 0.24,
                    y: groundY - h * 0.14
                )
                .animation(.easeInOut(duration: 1.0), value: personShifted)
        }
        .clipShape(RoundedRectangle(cornerRadius: DesignTokens.Radius.lg))
        .accessibilityLabel("A person moves from beside a building to an open area, away from a tree and power lines.")
    }

    private var tipsList: some View {
        VStack(alignment: .leading, spacing: DesignTokens.Spacing.xs) {
            OutdoorTipRow(symbol: "building.2.fill", text: "Stay away from buildings and falling debris.")
            OutdoorTipRow(symbol: "tree.fill", text: "Keep clear of trees and overhead branches.")
            OutdoorTipRow(symbol: "bolt.fill", text: "Avoid power lines and utility poles.")
        }
    }
}

private struct OutdoorTipRow: View {
    var symbol: String
    var text: String

    var body: some View {
        HStack(alignment: .top, spacing: DesignTokens.Spacing.sm) {
            Image(systemName: symbol)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(DesignTokens.Palette.urgencyAccent)
                .frame(width: 24)
            Text(text)
                .font(DesignTokens.FontScale.caption)
                .foregroundStyle(DesignTokens.Palette.softInk)
                .multilineTextAlignment(.leading)
            Spacer(minLength: 0)
        }
    }
}

private struct OutdoorBuilding: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: DesignTokens.Radius.sm)
                    .fill(Color(red: 0.78, green: 0.74, blue: 0.68))
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)

                VStack(spacing: h * 0.06) {
                    ForEach(0..<4, id: \.self) { row in
                        HStack(spacing: w * 0.10) {
                            ForEach(0..<2, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color(red: 0.55, green: 0.68, blue: 0.78))
                                    .frame(width: w * 0.22, height: h * 0.12)
                            }
                        }
                        .opacity(row == 3 ? 0.85 : 1)
                    }
                }
                .padding(.top, h * 0.10)
                .padding(.horizontal, w * 0.10)
            }
        }
    }
}

private struct OutdoorTree: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Rectangle()
                    .fill(Color(red: 0.48, green: 0.36, blue: 0.24))
                    .frame(width: w * 0.16, height: h * 0.36)
                    .position(x: w * 0.5, y: h * 0.82)

                Circle()
                    .fill(Color(red: 0.36, green: 0.58, blue: 0.36))
                    .frame(width: w * 0.9, height: w * 0.9)
                    .position(x: w * 0.5, y: h * 0.38)

                Circle()
                    .fill(Color(red: 0.42, green: 0.64, blue: 0.40))
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.30, y: h * 0.28)

                Circle()
                    .fill(Color(red: 0.42, green: 0.64, blue: 0.40))
                    .frame(width: w * 0.55, height: w * 0.55)
                    .position(x: w * 0.72, y: h * 0.30)
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 4, y: 2)
        }
    }
}

private struct OutdoorPowerLine: View {
    var body: some View {
        GeometryReader { proxy in
            let w = proxy.size.width
            let h = proxy.size.height
            ZStack {
                Rectangle()
                    .fill(Color(red: 0.55, green: 0.42, blue: 0.32))
                    .frame(width: w * 0.06, height: h * 0.85)
                    .position(x: w * 0.5, y: h * 0.55)

                Rectangle()
                    .fill(Color(red: 0.55, green: 0.42, blue: 0.32))
                    .frame(width: w * 0.72, height: h * 0.04)
                    .position(x: w * 0.5, y: h * 0.20)

                OutdoorCableShape(startY: 0.22, endY: 0.30)
                    .stroke(DesignTokens.Palette.softInk.opacity(0.6), lineWidth: 1.4)

                OutdoorCableShape(startY: 0.24, endY: 0.36)
                    .stroke(DesignTokens.Palette.softInk.opacity(0.5), lineWidth: 1.2)
            }
        }
    }
}

private struct OutdoorCableShape: Shape {
    var startY: CGFloat
    var endY: CGFloat

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX + rect.width * 0.15, y: rect.height * startY))
        p.addQuadCurve(
            to: CGPoint(x: rect.maxX - rect.width * 0.15, y: rect.height * startY),
            control: CGPoint(x: rect.midX, y: rect.height * endY)
        )
        return p
    }
}

private struct OutdoorWarningBadge: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(DesignTokens.Palette.urgencyAccent)
                .shadow(color: DesignTokens.Palette.softShadow, radius: 4, y: 2)
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

private struct OutdoorStandingPerson: View {
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
                    .position(x: w * 0.5, y: h * 0.42)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.30)
                    .position(x: w * 0.42, y: h * 0.74)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.16, height: h * 0.30)
                    .position(x: w * 0.58, y: h * 0.74)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(15), anchor: .top)
                    .position(x: w * 0.30, y: h * 0.36)

                Capsule()
                    .fill(DesignTokens.Palette.softInk)
                    .frame(width: w * 0.14, height: h * 0.28)
                    .rotationEffect(.degrees(-15), anchor: .top)
                    .position(x: w * 0.70, y: h * 0.36)
            }
            .shadow(color: DesignTokens.Palette.softShadow, radius: 5, y: 3)
        }
    }
}

#Preview {
    OutdoorSafetyView(onContinue: {})
}
