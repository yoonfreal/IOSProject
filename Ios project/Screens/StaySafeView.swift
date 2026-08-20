import SwiftUI

struct StaySafeView: View {
    var onReplay: () -> Void

    @State private var shieldVisible = false
    @State private var checkProgress: CGFloat = 0
    @State private var textVisible = false
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

            VStack(spacing: DesignTokens.Spacing.lg) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(DesignTokens.Palette.successAccent.opacity(0.12))
                        .frame(width: 220, height: 220)
                        .scaleEffect(shieldVisible ? 1 : 0.6)
                        .opacity(shieldVisible ? 1 : 0)

                    ShieldShape()
                        .fill(DesignTokens.Palette.successAccent)
                        .frame(width: 140, height: 160)
                        .shadow(color: DesignTokens.Palette.softShadow, radius: 14, y: 6)
                        .scaleEffect(shieldVisible ? 1 : 0.4)
                        .opacity(shieldVisible ? 1 : 0)

                    CheckmarkShape()
                        .trim(from: 0, to: checkProgress)
                        .stroke(.white, style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                        .frame(width: 76, height: 60)
                        .offset(y: 4)
                }

                VStack(spacing: DesignTokens.Spacing.sm) {
                    Text("Preparedness saves lives")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                        .multilineTextAlignment(.center)
                    Text("You practiced the moves that matter most.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, DesignTokens.Spacing.lg)
                .opacity(textVisible ? 1 : 0)
                .offset(y: textVisible ? 0 : 12)

                Spacer()

                Button("Replay", action: onReplay)
                    .buttonStyle(PrimaryButtonStyle(tint: DesignTokens.Palette.calmAccent))
                    .opacity(buttonVisible ? 1 : 0)
                    .accessibilityLabel("Replay the earthquake safety experience from the beginning")

                Spacer(minLength: DesignTokens.Spacing.md)
            }
        }
        .task {
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(DesignTokens.Motion.spring) {
                shieldVisible = true
            }
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(.easeOut(duration: 0.6)) {
                checkProgress = 1
            }
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(DesignTokens.Motion.easeGentle) {
                textVisible = true
            }
            try? await Task.sleep(for: .milliseconds(500))
            withAnimation(DesignTokens.Motion.easeGentle) {
                buttonVisible = true
            }
        }
    }
}

private struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let h = rect.height
        p.move(to: CGPoint(x: rect.midX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: h * 0.18))
        p.addLine(to: CGPoint(x: rect.maxX, y: h * 0.58))
        p.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control: CGPoint(x: rect.maxX, y: h * 0.92)
        )
        p.addQuadCurve(
            to: CGPoint(x: rect.minX, y: h * 0.58),
            control: CGPoint(x: rect.minX, y: h * 0.92)
        )
        p.addLine(to: CGPoint(x: rect.minX, y: h * 0.18))
        p.closeSubpath()
        return p
    }
}

private struct CheckmarkShape: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.midY))
        p.addLine(to: CGPoint(x: rect.width * 0.4, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height * 0.1))
        return p
    }
}

#Preview {
    StaySafeView(onReplay: {})
}
