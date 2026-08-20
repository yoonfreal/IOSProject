import SwiftUI

private struct AftermathItem: Identifiable {
    let id = UUID()
    let symbol: String
    let title: String
    let detail: String
    var checked: Bool = false
}

struct AftermathView: View {
    var onContinue: () -> Void

    @State private var items: [AftermathItem] = [
        AftermathItem(symbol: "waveform.path",
                      title: "Brace for aftershocks",
                      detail: "Smaller quakes may follow. Stay ready to Drop, Cover, Hold On again."),
        AftermathItem(symbol: "door.left.hand.open",
                      title: "Safe to leave?",
                      detail: "Check for structural damage before moving."),
        AftermathItem(symbol: "exclamationmark.triangle.fill",
                      title: "Avoid damaged objects",
                      detail: "Stay clear of anything fallen or unstable."),
        AftermathItem(symbol: "flame.fill",
                      title: "Check for gas leaks",
                      detail: "Turn off the gas if you smell anything odd. Open a window if you can."),
        AftermathItem(symbol: "figure.stairs",
                      title: "Evacuate only if unsafe",
                      detail: "Gas, fire, or unsound structure? Take the stairs — never elevators.")
    ]

    var body: some View {
        ZStack {
            DesignTokens.Palette.calmBackground.ignoresSafeArea()

            VStack(spacing: DesignTokens.Spacing.md) {
                Spacer(minLength: DesignTokens.Spacing.sm)

                VStack(spacing: DesignTokens.Spacing.xs) {
                    Text("Aftermath check")
                        .font(DesignTokens.FontScale.title)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                    Text("Tap each item as you check it off.")
                        .font(DesignTokens.FontScale.body)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, DesignTokens.Spacing.lg)
                }

                VStack(spacing: DesignTokens.Spacing.sm) {
                    ForEach($items) { $item in
                        AftermathRow(item: $item)
                    }
                }
                .padding(.horizontal, DesignTokens.Spacing.md)

                Button("Done", action: onContinue)
                    .buttonStyle(PrimaryButtonStyle(tint: DesignTokens.Palette.successAccent))
                    .disabled(!allChecked)
                    .opacity(allChecked ? 1 : 0.4)
                    .scaleEffect(allChecked ? 1 : 0.96)
                    .animation(DesignTokens.Motion.spring, value: allChecked)
                    .accessibilityLabel(allChecked ? "Finish the aftermath check" : "Check every item to finish")

                Spacer(minLength: DesignTokens.Spacing.sm)
            }
        }
    }

    private var allChecked: Bool {
        items.allSatisfy { $0.checked }
    }
}

private struct AftermathRow: View {
    @Binding var item: AftermathItem

    var body: some View {
        Button {
            withAnimation(DesignTokens.Motion.spring) {
                item.checked.toggle()
            }
        } label: {
            HStack(spacing: DesignTokens.Spacing.md) {
                Image(systemName: item.symbol)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(item.checked ? DesignTokens.Palette.successAccent : DesignTokens.Palette.calmAccent)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle().fill((item.checked ? DesignTokens.Palette.successAccent : DesignTokens.Palette.calmAccent).opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(DesignTokens.FontScale.button)
                        .foregroundStyle(DesignTokens.Palette.softInk)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(item.detail)
                        .font(DesignTokens.FontScale.caption)
                        .foregroundStyle(DesignTokens.Palette.mutedInk)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ZStack {
                    Circle()
                        .stroke(DesignTokens.Palette.mutedInk.opacity(0.3), lineWidth: 2)
                        .frame(width: 28, height: 28)
                    if item.checked {
                        Circle()
                            .fill(DesignTokens.Palette.successAccent)
                            .frame(width: 28, height: 28)
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .padding(DesignTokens.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: DesignTokens.Radius.md)
                    .fill(DesignTokens.Palette.calmSurface)
                    .shadow(color: DesignTokens.Palette.softShadow, radius: 8, y: 3)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(item.title). \(item.detail). \(item.checked ? "Checked." : "Not checked.")")
    }
}

#Preview {
    AftermathView(onContinue: {})
}
