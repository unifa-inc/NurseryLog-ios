import UIKit

// MARK: - Superellipse

public struct Superellipse {
    public let bezierPath: UIBezierPath

    public init(in rect: CGRect, coefficient: CGFloat) {
        let path = UIBezierPath(ovalIn: rect)

        let handleX: CGFloat = rect.size.width * coefficient / 2
        let handleY: CGFloat = rect.size.height * coefficient / 2

        let left = CGPoint(x: rect.minX, y: rect.midY)
        let top = CGPoint(x: rect.midX, y: rect.minY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        let bottom = CGPoint(x: rect.midX, y: rect.maxY)

        path.move(to: left)
        path.addCurve(
            to: top,
            controlPoint1: CGPoint(x: left.x, y: left.y - handleY),
            controlPoint2: CGPoint(x: top.x - handleX, y: top.y)
        )
        path.addCurve(
            to: right,
            controlPoint1: CGPoint(x: top.x + handleX, y: top.y),
            controlPoint2: CGPoint(x: right.x, y: right.y - handleY)
        )
        path.addCurve(
            to: bottom,
            controlPoint1: CGPoint(x: right.x, y: right.y + handleY),
            controlPoint2: CGPoint(x: bottom.x + handleX, y: bottom.y)
        )
        path.addCurve(
            to: left,
            controlPoint1: CGPoint(x: bottom.x - handleX, y: bottom.y),
            controlPoint2: CGPoint(x: left.x, y: left.y + handleY)
        )
        path.close()
        bezierPath = path
    }
}

// MARK: - SuperellipseView

public final class SuperellipseView: UIView {
    var coefficient: CGFloat = 0.75

    override public func layoutSubviews() {
        super.layoutSubviews()
        let path = Superellipse(in: bounds, coefficient: coefficient).bezierPath
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
