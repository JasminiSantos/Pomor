import SwiftUI
import PomorDesignSystem

struct TomatoMark: View {
    var size: CGFloat = 32
    var isFloating: Bool = false

    @State private var isLifted = false

    var body: some View {
        canvas
            .frame(width: size, height: size)
            .offset(y: isFloating && isLifted ? -8 : 0)
            .animation(
                isFloating
                    ? .easeInOut(duration: 1.6).repeatForever(autoreverses: true)
                    : nil,
                value: isLifted
            )
            .onAppear {
                guard isFloating else { return }
                isLifted = true
            }
    }

    private var canvas: some View {
        Canvas { context, canvasSize in
            let s = canvasSize.width / 64
            let ink = PomorColor.Illustration.self

            func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint {
                CGPoint(x: x * s, y: y * s)
            }

            var leftLeaf = Path()
            leftLeaf.move(to: p(32, 14))
            leftLeaf.addCurve(to: p(22, 10), control1: p(32, 14), control2: p(28, 8))
            leftLeaf.addCurve(to: p(32, 14), control1: p(26, 12), control2: p(28, 16))
            leftLeaf.closeSubpath()
            context.fill(leftLeaf, with: .color(ink.leaf))

            var rightLeaf = Path()
            rightLeaf.move(to: p(32, 14))
            rightLeaf.addCurve(to: p(42, 9), control1: p(32, 14), control2: p(36, 7))
            rightLeaf.addCurve(to: p(32, 14), control1: p(38, 11), control2: p(35, 15))
            rightLeaf.closeSubpath()
            context.fill(rightLeaf, with: .color(ink.leafDark))

            var stem = Path()
            stem.move(to: p(32, 14))
            stem.addLine(to: p(32, 20))
            context.stroke(
                stem,
                with: .color(ink.leaf),
                style: StrokeStyle(lineWidth: 2.5 * s, lineCap: .round)
            )

            let body = Path(ellipseIn: CGRect(x: 12 * s, y: 16 * s, width: 40 * s, height: 40 * s))
            context.fill(body, with: .color(ink.tomato))

            context.drawLayer { layer in
                let center = p(25, 27)
                layer.translateBy(x: center.x, y: center.y)
                layer.rotate(by: .degrees(-20))
                layer.translateBy(x: -center.x, y: -center.y)
                let shine = Path(ellipseIn: CGRect(
                    x: 20 * s, y: 23.5 * s,
                    width: 10 * s, height: 7 * s
                ))
                layer.fill(shine, with: .color(ink.shine))
            }

            var ribFill = Path()
            ribFill.move(to: p(32, 18))
            ribFill.addQuadCurve(to: p(32, 36), control: p(38, 26))
            ribFill.addQuadCurve(to: p(32, 18), control: p(26, 26))
            ribFill.closeSubpath()
            context.fill(ribFill, with: .color(ink.rib))

            var leftRib = Path()
            leftRib.move(to: p(32, 18))
            leftRib.addQuadCurve(to: p(28, 38), control: p(24, 28))
            context.stroke(leftRib, with: .color(ink.ribStroke), lineWidth: 1.5 * s)

            var rightRib = Path()
            rightRib.move(to: p(32, 18))
            rightRib.addQuadCurve(to: p(36, 38), control: p(40, 28))
            context.stroke(rightRib, with: .color(ink.ribStroke), lineWidth: 1.5 * s)
        }
    }
}
