//
//  PinInputView.swift
//
//
//  Created by Peter IJlst
//

import UIKit

public protocol PinInputDelegate: class {
    func itemSelected(_ item: Key)
}

public struct PinInputViewConfiguration {
    
    let layout: [[Key]]
    let buttonStyleClosure: ((UIButton, Key) -> Void)?
    
    public static var standard: PinInputViewConfiguration {
        return PinInputViewConfiguration(layout: [[.one, .two, .three],
                                      [.four, .five, .six],
                                      [.seven, .eight, .nine],
                                      [.option, .zero, .backspace]],
                             buttonStyleClosure: nil)
    }
    
    public init(layout: [[Key]], buttonStyleClosure: ((UIButton, Key) -> Void)?) {
        self.layout = layout
        self.buttonStyleClosure = buttonStyleClosure
    }
}

class PinInputView: UIStackView {
    
    // MARK: - Public Properties

    /// Configuration of this component
    var configuration = PinInputViewConfiguration.standard { didSet { render() } }
    
    /// Delegate of input
    weak var delegate: PinInputDelegate?

    // MARK: - Private Properties
    
    /// Width multiplier for a row
    private var widthMultiplier: CGFloat {
        return CGFloat(1 / (configuration.layout.first?.count ?? 3))
    }
    
    /// Height multiplier for a row
    private var heightMultiplier: CGFloat {
        return CGFloat(1 / configuration.layout.count)
    }
    
    /// The rows of input buttons
    private var keyPadRows: [UIView] {
        
        return configuration.layout.map {
            
            var buttonConstraints: [NSLayoutConstraint] = []

            let stack = UIStackView(arrangedSubviews: $0.map {
                let button = createButton(from: $0)
                buttonConstraints.append(contentsOf: [
                    button.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier),
                    button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: widthMultiplier)
                ])
                return button
            })
            
            buttonConstraints.forEach { $0.isActive = true }

            stack.axis = .horizontal
            stack.distribution = .fillEqually
            stack.alignment = .fill
            
            return stack
        }
    }
    
    // MARK: - Lifecycle
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        distribution = .fillEqually
        alignment = .fill
        
        render()
    }
    
    // MARK: - Private
    
    /// Render UI
    private func render() {
        arrangedSubviews.forEach {
            removeConstraints($0.constraints)
            $0.removeFromSuperview()
        }
        keyPadRows.forEach {
            addArrangedSubview($0)
            $0.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            $0.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier).isActive = true
        }
    }
    
    /// Create a button from a KeyPadItem
    ///
    /// - Parameter keyPadItem: keypad item
    /// - Returns: buttom representing keypad item
    private func createButton(from key: Key) -> UIButton {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(digitPressed), for: .touchUpInside)
        button.tag = key.identifier
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        
        switch key.type {
        case .number:
            button.setTitle(key.identifier.description, for: .normal)
        case .backspace:
            button.setTitle("⌫", for: .normal)
        default: break
        }
        
        if let overrideButtonStyle = configuration.buttonStyleClosure {
            overrideButtonStyle(button, key)
        }
        
        return button
    }
    
    // MARK: - Public
    
    /// Digit Pressed
    ///
    /// - Parameter item: the button that was pressed
    @objc func digitPressed(_ item: UIButton) {
        let key = Key.from(value: item.tag)
        delegate?.itemSelected(key)
    }
}
