# When the Earth Moves — Final Build Spec

WWDC Student Challenge submission. iOS/iPadOS app, SwiftUI only, fully offline, 3-minute interactive experience teaching earthquake safety.

##Project: When the Earth Moves

This is an individual project for the Apple WWDC Student Challenge — a fully offline, SwiftUI-only iPhone experience that teaches earthquake safety through direct interaction rather than passive reading. The whole thing runs in about 2–3 minutes: the player starts in an ordinary room, preps it for safety by moving hazards out of the way, lives through a simulated earthquake, makes a real-time survival choice (with visible consequences if they choose wrong), performs the actual Drop-Cover-Hold-On steps through gesture, checks their surroundings afterward, and closes on a "preparedness saves lives" message.

The point isn't a full earthquake simulator — it's a short, polished, story-driven safety lesson. Technical priorities in order: (1) clean gesture-driven interaction (tap, drag, long-press, pinch — no networking, no external assets, everything built from SwiftUI shapes), (2) a calm, Apple-style visual polish rather than a sketch/wireframe look, (3) a clear narrative arc from ordinary day → crisis → correct response → safety, and (4) accessibility (Dynamic Type, accessibility labels) throughout.

## Hard constraints
- SwiftUI only — no UIKit, no Storyboards
- Zero networking — no URLSession, no external calls
- All assets local — build everything with SwiftUI shapes, Paths, and SF Symbols (no image files needed)
- State via @State, @Binding, and @Observable
- Support Dynamic Type and accessibilityLabel on every interactive element
- Target iOS 17+, SwiftUI only, Universal device support

## Code style (follow exactly)
- No inline comments in code — keep code clean, explain reasoning in chat instead
- No unrelated refactors — only touch what's being asked for in each step
- Descriptive variable/function names per Swift API Design Guidelines
- Prefer small, composable views (one file per screen) over one giant ContentView

---

## Screen flow (8 screens total)

1. **A normal day** — room scene, ambient dwell (curtains sway ~2s before button fades in), tap "tap to start"
2. **Prep the room** *(new)* — drag 2–3 hazard objects (bookshelf, lamp, clock) into safer marked zones before the quake hits; button to continue appears only once all hazards are placed
3. **Earthquake begins** — shake animation plays for 2–3s before "continue" fades in (don't let it be tappable instantly)
4. **Make a choice** — question + 3 tappable option cards
   - **Run outside (wrong)** → cut to consequence screen: bookshelf toppling near the exit, debris falling, shake continues — auto-returns to screen 4 after ~1.8s
   - **Stand by window (wrong)** → cut to consequence screen: window cracking, jagged fracture animating across the glass — auto-returns to screen 4 after ~1.8s
   - **Hide under table (correct)** → advances to screen 5
5. **Drop, cover, hold on** — tap person to crouch, drag table over the person (snaps into place near a target zone), long-press the "+" button for 1.5–2s (visible fill/progress ring) to advance
6. **Aftermath check** — 4-item tappable checklist (safe to leave? / avoid damaged objects / check for gas leaks / bring emergency kit), "done" enabled once all 4 are checked
7. **Inspect the damage** *(new)* — pinch-to-zoom (MagnificationGesture) into a cracked wall or toppled shelf illustration to see the damage up close before proceeding; tap/pinch-out to continue
8. **Stay safe (closing)** — shield + checkmark animates in with a slight delay, "preparedness saves lives," replay button loops back to screen 1

Target total runtime: **2:00–2:30** on a clean first run (with retry loops on screen 4 adding time if the player picks wrong).

---

## Visual design direction

This should NOT look like a wireframe or sketch — build a clean, polished, "Apple Human Interface" style UI:

- **Typography**: system font (SF Pro via `.font(.system(...))`), generous type scale — large rounded titles for screen headers, medium body text for instructions
- **Color palette**: soft, calm neutral background (warm off-white or light gray) for the "safe" screens; shift to warmer amber/red undertones during the earthquake and consequence screens to convey urgency, then settle back to calm tones by the closing screen — this color shift IS the primary way you communicate emotional state, use it deliberately
- **Shapes over illustrations**: build the room, character, and objects entirely from `RoundedRectangle`, `Circle`, `Path`, `Capsule`, layered with soft shadows and rounded corners — think flat, modern, geometric — not literal/detailed illustration
- **Motion**: every screen transition uses `withAnimation(.easeInOut)` or `.spring()` — nothing should cut instantly except intentional consequence-screen cuts (those can be abrupt on purpose, for impact)
- **Depth**: subtle `.shadow()` on cards/buttons only, no heavy gradients or skeuomorphism
- **Consistency**: define a small design-token file (colors, spacing, corner radius, font sizes as constants) and reuse across every screen rather than hardcoding values per view

---

## Screen-by-screen build notes

### Screen 1 — A normal day
- Room built from shapes: window (rounded rect + cross divider), curtain (two soft-curved paths), bookshelf (rect with hatch-free horizontal shelves), table, chair, character (circle head + capsule body)
- Curtain gently sways via a slow, subtle rotation animation, looping
- "tap to start" button fades in after ~2s delay using `.opacity` + `withAnimation` + `DispatchQueue` or `Task.sleep`

### Screen 2 — Prep the room (new)
- 2–3 hazard objects (e.g. bookshelf, table lamp) start in unsafe positions
- Each hazard is draggable via `DragGesture`, with a highlighted "safe zone" target rectangle
- On drop within the target zone's bounds, snap the object into place with a spring animation and mark it complete (e.g. subtle checkmark or color shift)
- "Continue" button is disabled/grayed until all hazards are placed, then enables with a fade

### Screen 3 — Earthquake begins
- Shake the whole scene using a small random offset animation on a timer, or `.modifier` with a repeating `withAnimation`
- Falling objects: 2–3 small shapes that animate downward with slight rotation
- "Continue" button appears via delayed opacity fade after ~2.5s

### Screen 4 — Make a choice + consequences
- Use an enum-driven state machine:
```
enum QuakeChoice { case none, runOutside, hideUnderTable, standByWindow }
@State private var selectedChoice: QuakeChoice = .none
```
- Tapping a choice sets `selectedChoice`; a `ZStack` or `switch` drives which view shows
- Wrong choices show a full-screen consequence view for ~1.8s (use `Task { try? await Task.sleep(for: .seconds(1.8)) }`) then reset `selectedChoice = .none`
- Correct choice calls a closure/binding to advance the parent's screen index

### Screen 5 — Drop, cover, hold on
- Person view has two states (standing/crouching) toggled by `.onTapGesture`
- Table view uses `DragGesture` with a target `CGRect`; on drag end, check if the table's frame overlaps the target, then snap with `.spring()`
- "+" hold button uses `LongPressGesture(minimumDuration: 1.8)` combined with a visible progress ring (`Circle().trim(from:to:)` animated alongside the press) — on gesture success, advance to screen 6

### Screen 6 — Aftermath check
- 4 checklist rows, each a button toggling a `Bool` in a `@State` array or `@Observable` model
- "Done" button `.disabled()` until all 4 are true, with an opacity/scale change when it becomes enabled

### Screen 7 — Inspect the damage (new)
- A cracked-wall or toppled-shelf illustration inside a `ScrollView` or fixed container
- `MagnificationGesture` scales the illustration via a `@State var scale: CGFloat = 1.0`, clamped between reasonable bounds (e.g. 1.0–2.5)
- A subtle hint text ("pinch to inspect") fades out after first interaction
- Tap or pinch back to ~1.0 scale to continue to screen 8

### Screen 8 — Stay safe (closing)
- Shield + checkmark shape animates in with a delayed scale/opacity entrance
- "Replay" button resets all `@State`/`@Observable` values and returns to screen 1

---

## Accessibility checklist (apply to every screen)
- Every tappable element has `.accessibilityLabel("...")` describing its action, not just its appearance
- Support Dynamic Type — avoid fixed frame heights on text containers that would clip larger text sizes
- Ensure color is never the only signal (e.g. pair the amber/red urgency tint with shape/motion cues too)

---

## Suggested build order for Claude Code
1. Scaffold all 8 screens as empty SwiftUI views with placeholder text, wire up navigation/state machine first
2. Build screen 1 fully (room shapes + ambient animation + delayed button) as the visual style reference for the rest
3. Build screens 3–4 (earthquake + choice + consequences) — this is the technical/interaction core
4. Build screen 5 (three gestures) — most complex, budget the most time here
5. Build screens 2 and 7 (the two new prep/inspect screens) using the design language established in step 2
6. Build screens 6 and 8
7. Pass over every screen for animation polish and accessibility labels last, once all logic works

