//
//  GATTProfile.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation
import Bluetooth
import GATT

public protocol GATTProfile {
    
    static var services: [GATTProfileService.Type] { get }
}

public protocol GATTProfileService {
    
    static var uuid: BluetoothUUID { get }
    static var isPrimary: Bool { get }
    static var characteristics: [GATTProfileCharacteristic.Type] { get }
}

public protocol GATTProfileCharacteristic {
    
    static var service: GATTProfileService.Type { get }
    static var uuid: BluetoothUUID { get }
    var data: Data { get }
    init?(data: Data)
}
