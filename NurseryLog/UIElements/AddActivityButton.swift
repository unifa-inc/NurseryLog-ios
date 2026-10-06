import UIKit

final class AddActivityButton: UIButton {
    private let superellipseCoefficient: CGFloat = 0.75
    private let shapeLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = Superellipse(in: bounds, coefficient: superellipseCoefficient).bezierPath.cgPath
        shapeLayer.path = path
        shapeLayer.frame = bounds
        layer.shadowPath = path
    }

    private func configure() {
        clipsToBounds = false
        backgroundColor = .clear
        shapeLayer.fillColor = DesignSystem.Color.primary.cgColor
        if let imageLayer = imageView?.layer {
            layer.insertSublayer(shapeLayer, below: imageLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        tintColor = UIColor.black.withAlphaComponent(0.7)
    }
}
