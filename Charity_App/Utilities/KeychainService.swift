//
//  KeychainService.swift
//  
//
//
//

import Foundation
import KeychainSwift

class KeychainService {
    var _localvar = KeychainSwift()
    
    var keyChain: KeychainSwift{
        get {
            return _localvar
        }
        set {
            _localvar = newValue
        }
    }
}

