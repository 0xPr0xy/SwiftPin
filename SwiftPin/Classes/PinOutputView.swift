//
//  PinOutputView.swift
//
//
//  Created by Peter IJlst
//

import UIKit

protocol PinOutputDelegate: class {
    func onCompleteInput(_ digits: Int...)
}
protocol PinOutput {
    func update(_ digits: [Int])
}

public struct PinOutputViewConfiguration {
    
    let maxDigits: Int
    let customDigitViewClosure: ((Bool) -> UIView)?
    let overrideCircleViewClosure: ((Bool, UIView) -> UIView)?
    
    static var standard: PinOutputViewConfiguration {
        return PinOutputViewConfiguration(maxDigits: 5,
                             customDigitViewClosure: nil,
                             overrideCircleViewClosure: nil)
    }
    
    public init(maxDigits: Int,
                customDigitViewClosure: ((Bool) -> UIView)?,
                overrideCircleViewClosure: ((Bool, UIView) -> UIView)?) {
        self.maxDigits = maxDigits
        self.customDigitViewClosure = customDigitViewClosure
        self.overrideCircleViewClosure = overrideCircleViewClosure
    }
}

class PinOutputView: UIStackView {
    // MARK: - Public Properties
    
    var configuration = PinOutputViewConfiguration.standard { didSet { render() } }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        alignment = .fill
        distribution = .fillEqually
        
        render()
    }
    
    // MARK: - Private
    
    /// Render x filled and x empty digits
    ///
    /// - Parameter digits: the filled digits
    private func render(_ digits: [Int] = []) {
        arrangedSubviews.forEach {
            $0.constraints.forEach { $0.isActive = false }
            $0.removeFromSuperview()
        }
        let customDigitViewClosure = configuration.customDigitViewClosure
        for _ in 0 ..< digits.count {
            let customView = customDigitViewClosure != nil ?
                customDigitViewClosure!(true) : createDigitView(isChecked: true)
            addArrangedSubview(customView)
        }
        for _ in digits.count ..< configuration.maxDigits {
            let customView = customDigitViewClosure != nil ?
                customDigitViewClosure!(false) : createDigitView(isChecked: false)
            addArrangedSubview(customView)
        }
    }
    
    
    /// Create a Digit View, with a Circle inside
    ///
    /// - Parameter isChecked: is the digit entered or not
    /// - Returns: the digit view
    private func createDigitView(isChecked: Bool) -> UIView {
        let circleViewContainer = UIView(frame: CGRect.zero)
        circleViewContainer.translatesAutoresizingMaskIntoConstraints = false

        var circleView = createCircle(isChecked: isChecked)
        
        // circle view override provided
        if let overrideCircleView = configuration.overrideCircleViewClosure {
            circleView = overrideCircleView(isChecked, circleView)
        }
        
        let circleWidth = circleView.frame.size.width

        circleViewContainer.addSubview(circleView)
        
        circleView.widthAnchor.constraint(equalToConstant: circleWidth).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: circleWidth).isActive = true
        circleView.centerXAnchor.constraint(equalTo: circleViewContainer.centerXAnchor).isActive = true

        return circleViewContainer
    }
    
    /// Create a Circle
    ///
    /// - Parameter isChecked: is the circle filled or not
    /// - Returns: the circle view
    private func createCircle(isChecked: Bool) -> UIView {
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        circleView.backgroundColor = isChecked ? .black : .gray
        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
        circleView.translatesAutoresizingMaskIntoConstraints = false
        return circleView
    }
}

// MARK: - PinOutput

extension PinOutputView: PinOutput {
    func update(_ digits: [Int]) {
        render(digits)
    }
}
