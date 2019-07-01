# SwiftPin

## Features

This project aims at providing a PinView usable for capturing and displaying input of digits

Configuration Options:

- pin length can be configured
- keyboard button can be configured
- pin digit view can be configured
- pin digit view's dot view can be configured
- keyboard layout can be configured

## Classes

SwiftPin consists of 4 classes:

- PinView
- PinViewInput
- PinViewOutput
- Key

### PinView

This view is receiving input from the PinViewInput and forwarding that input to PinViewOutput. it also sends PinEvents to the delegate

### PinViewInput

This view is responsible for displaying a keyboard for input of the digits.

### PinViewOutput

This view is responsible for displaying the amount of digits entered and the amount of digits still to enter.

### Key

Definition of the keys we support for input.
Currently this is numbers from 0 - 9, option and backspace


## Installation

### Cococapods

add pod:

``` swift
pod 'SwiftPin', :git => 'https://github.com/0xPr0xy/SwiftPin.git'
```
and install with `pod install`

## Usage

In your UIViewController xib or storyboard,
Add a UIView and add constraints for size and positioning in it's super view.
Then set the UIView class to `PinView` and it's module to `SwiftPin` and connect it to your ViewController:

``` swift
@IBOutlet weak var pinView: PinView!
```

Import the library:

``` swift
import PinView
```

Then set the UIViewController as delegate of `PinView`:

``` swift
pinView.delegate = self
```

Implement the `PinViewDelegate` protocol:

``` swift
extension UnlockViewController: PinViewDelegate {

    var clearInputOnCompleted: Bool { return false }

    func handle(_ event: PinEvent) {

    }
}
```

Implement the `PinViewConfigurationProvider` protocol:

``` swift
extension UnlockViewController: PinViewConfigurationProvider {

    var pinInputViewConfiguration: PinInputViewConfiguration {
        return PinInputViewConfiguration.standard
    }
    var pinOutputViewConfiguration: PinOutputViewConfiguration {
        return PinOutputViewConfiguration.standard
    }
}
```

## Screenshots

Standard

![standard](screenshots/standard.png)

Custom

![custom](screenshots/custom.png)

