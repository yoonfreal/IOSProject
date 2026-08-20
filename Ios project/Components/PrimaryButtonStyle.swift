import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    var tint: Color = DesignTokens.Palette.calmAccent

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(DesignTokens.FontScale.button)
            .foregroundStyle(.white)
            .padding(.vertical, DesignTokens.Spacing.sm + 2)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .background(Capsule().fill(tint))
            .shadow(color: DesignTokens.Palette.softShadow, radius: 12, y: 5)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.92 : 1.0)
            .animation(DesignTokens.Motion.quick, value: configuration.isPressed)
    }
}
