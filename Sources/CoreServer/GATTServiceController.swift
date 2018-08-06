//
//  GATTServiceController.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation
import Bluetooth
import GATT

public protocol GATTServiceController: class {
    
    static var service: GATTProfileService.Type { get }
    var peripheral: PeripheralProtocol { get }
    init(peripheral: PeripheralProtocol) throws
    
    func willRead(_ request: GATTReadRequest) -> ATT.Error?
    func willWrite(_ request: GATTWriteRequest) -> ATT.Error?
    func didWrite(_ request: GATTWriteConfirmation)
}
