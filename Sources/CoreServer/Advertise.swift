//
//  Advertise.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation
import Bluetooth

public enum ScanResponseDataError: Error {
    
    case dataOverflow(Data)
}

public extension BluetoothHostControllerInterface {
    
    func setScanResponse(timeout: HCICommandTimeout = .default) throws {
        
        let name: GAPCompleteLocalName = "Pi-Sensors"
        let data = GAPDataEncoder.encode([name])
        
        guard let scanResponseData = LowEnergyAdvertisingData(data: data) else {
            throw ScanResponseDataError.dataOverflow(data)
        }
        
        try setLowEnergyScanResponse(scanResponseData, timeout: timeout)
    }

    func setAdvertisingData(interval: UInt16 = 200, timeout: HCICommandTimeout = .default) throws {
        
        let uidBytes: [UInt8] = [0x10, 0x10, 0x10, 0x10, 0x10, 0x10]
        
        var command = HCILESetAdvertisingData()
        command.advertisingData.length = 0x07 // total length
        command.advertisingData.bytes.0 = 0x06 // length id
        command.advertisingData.bytes.1 = uidBytes[0]
        command.advertisingData.bytes.2 = uidBytes[1]
        command.advertisingData.bytes.3 = uidBytes[2]
        command.advertisingData.bytes.4 = uidBytes[3]
        command.advertisingData.bytes.5 = uidBytes[4]
        command.advertisingData.bytes.6 = uidBytes[5]
        
        try deviceRequest(command, timeout: timeout)
        
        // start advertising
        do {
            try enableLowEnergyAdvertising(timeout: timeout)
        } catch HCIError.commandDisallowed {}
    }
}
