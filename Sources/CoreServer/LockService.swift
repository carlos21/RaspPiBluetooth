//
//  LockService.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/5/18.
//

import Foundation
import Bluetooth

public extension SensorsProfile {
    
    public struct LockService: GATTProfileService {
        
        public static var uuid: BluetoothUUID = BluetoothUUID(rawValue: "3fece20e-990f-11e8-9eb6-529269fb1459")!
        public static var isPrimary: Bool = true
        public static var characteristics: [GATTProfileCharacteristic.Type] = [Command.self]
        
        public enum Command: UInt8, GATTProfileCharacteristic {
            
            public static let service: GATTProfileService.Type = LockService.self
            public static let uuid: BluetoothUUID = BluetoothUUID(rawValue: "27a80732-990f-11e8-9eb6-529269fb1459")!
            internal static let length = 1
            
            case open = 0x01
            case close = 0x02
            
            public init?(data: Data) {
                
                guard data.count == type(of: self).length else { return nil }
                guard let value = Command(rawValue: data[0]) else { return nil }
                self = value
            }
            
            public var data: Data {
                
                return Data([rawValue])
            }
        }
    }
}
