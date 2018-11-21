//
//  PinView.swift
//
//
//  Created by Peter IJlst
//

import UIKit

enum PinEvent {
    case inputChanged(current: [Int])
    case inputCompleted(current: [Int])
    case optionPressed
    case backspacePressed
}

protocol PinViewDelegate: class {
    func handle(_ event: PinEvent)
    var clearInputOnCompleted: Bool { get }
}

protocol PinViewConfigurationProvider {
    var pinOutputViewConfiguration: PinOutputViewConfiguration { get }
    var pinInputViewConfiguration: PinInputViewConfiguration { get }
}


class PinView: UIView {
    
    // MARK: - Public Properties
    
    /// Delegate of this component
    var delegate: (PinViewDelegate & PinViewConfigurationProvider)? {
        didSet {
            guard let delegate = delegate else { return }
            input.configuration = delegate.pinInputViewConfiguration
            output.configuration = delegate.pinOutputViewConfiguration
        }
    }
    
    // MARK: - Private Properties
    
    /// Required pin length
    private var requiredLength: Int {
        return output.configuration.maxDigits
    }
    
    /// Current digits
    private var digits: [Int] = []
    
    /// Digit display
    private let output: PinOutputView
    
    /// Keypad
    private let input: PinInputView
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        output = PinOutputView(frame: frame)
        input = PinInputView(frame: frame)
        super.init(frame: frame)
        self.frame = frame

        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        output = PinOutputView(coder: aDecoder)
        input = PinInputView(coder: aDecoder)

        super.init(coder: aDecoder)

        initialize()
    }
    
    private func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(output)
        createOutputConstraints()
        
        addSubview(input)
        createInputConstraints()
        
        input.delegate = self
    }
    
    // MARK: - Public
    
    func clearInput() {
        digits.removeAll()
        output.update(digits)
    }
    
    // MARK: - Private
    
    private func createOutputConstraints() {
        output.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        output.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.25).isActive = true
        output.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        output.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    private func createInputConstraints() {
        input.topAnchor.constraint(equalTo: output.bottomAnchor).isActive = true
        input.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.75).isActive = true
        input.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
}

// MARK: - PinInputDelegate

extension PinView: PinInputDelegate {
    
    /// Pin Input
    ///
    /// - Parameter item: the selected item
    func itemSelected(_ item: Key) {
        switch item.type {
        
        case .backspace:
            // check if we are not at min of input
            guard digits.count > 0 else { return }
            
            // remove last
            digits.removeLast()
            output.update(digits)
            
            // send events backspacePressed and inputChanged
            delegate?.handle(.backspacePressed)
            delegate?.handle(.inputChanged(current: digits))
            
        case .number:
            // check if we are not at max of input
            guard digits.count < requiredLength else { return }
            
            // add digit
            digits.append(item.identifier)
            output.update(digits)
            
            if digits.count == requiredLength { // if pin length reached
                
                // inputCompleted event
                delegate?.handle(.inputCompleted(current: digits))
                
                // optional clear input
                if delegate?.clearInputOnCompleted ?? true {
                    clearInput()
                }
            } else {
                delegate?.handle(.inputChanged(current: digits)) // inputChanged event
            }
       
        case .option:
            delegate?.handle(.optionPressed)
        
        default: break
        }
    }
}
