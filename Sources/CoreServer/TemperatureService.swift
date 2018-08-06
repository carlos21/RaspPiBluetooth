//
//  TemperatureSensorService.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation
import Bluetooth

public extension SensorsProfile {
    
    public struct TemperatureService: GATTProfileService {
        
        public static var uuid: BluetoothUUID = BluetoothUUID(rawValue: "")!
        public static var isPrimary: Bool = true
        public static var characteristics: [GATTProfileCharacteristic.Type] = []
        
        public enum Command: UInt8, GATTProfileCharacteristic {
            
            public static let service: GATTProfileService.Type = LockService.self
            public static let uuid: BluetoothUUID = BluetoothUUID(rawValue: "")!
            internal static let length = 1
            
            case readTemperature = 0x01
            case readHumidity = 0x02
            
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
