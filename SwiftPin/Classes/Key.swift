//
//  Key.swift
//
//
//  Created by Peter IJlst
//
import Foundation

enum Key {
    
    case zero, one, two, three, four, five, six, seven, eight, nine
    case option, backspace, empty
    
    enum KeyType {
        case number, backspace, option, empty
    }
    
    var identifier: Int {
        switch self {
        case .zero: return 0
        case .one:  return 1
        case .two:  return 2
        case .three: return 3
        case .four: return 4
        case .five: return 5
        case .six: return 6
        case .seven: return 7
        case .eight: return 8
        case .nine: return 9
        case .option: return 999
        case .backspace: return -1
        case .empty: return 888
        }
    }
    
    var type: KeyType {
        switch self {
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine: return .number
        case .option: return .option
        case .backspace: return .backspace
        case .empty: return .empty
        }
    }
    
    static func from(value: Int) -> Key {
        switch value {
        case 0: return .zero
        case 1: return .one
        case 2: return .two
        case 3: return .three
        case 4: return .four
        case 5: return .five
        case 6: return .six
        case 7: return .seven
        case 8: return .eight
        case 9: return .nine
        case 999: return .option
        case -1: return .backspace
        default: return .empty
        }
    }
}
