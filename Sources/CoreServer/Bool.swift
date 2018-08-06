//
//  Bool.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/5/18.
//

import Foundation

internal extension Bool {
    
    init?(byteValue: UInt8) {
        
        switch byteValue {
        case 0x00: self = false
        case 0x01: self = true
        default: return nil
        }
    }
    
    var byteValue: UInt8 {
        
        return self ? 0x01 : 0x00
    }
}
