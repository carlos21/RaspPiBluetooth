//
//  LockServiceController.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation
import Bluetooth
import GATT
import SwiftyGPIO

public class LockServiceController: GATTServiceController {
    
    public typealias LockService = SensorsProfile.LockService
    public typealias Command = SensorsProfile.LockService.Command
    
    // MARK: - Properties
    
    public var peripheral: PeripheralProtocol
    internal let serviceHandle: UInt16
    internal let commandHandle: UInt16
    public static var service: GATTProfileService.Type { return LockService.self }
    private var servoMotor: ServoMotor?
    // MARK: - Initialization
    
    public required init(peripheral: PeripheralProtocol) throws {
        
        self.peripheral = peripheral
        
        #if os(Linux)
        let notifyDescriptors = [GATTClientCharacteristicConfiguration().descriptor]
        #elseif os(macOS)
        let notifyDescriptors: [GATT.Descriptor] = []
        #endif
        
        let characteristics = [
            GATT.Characteristic(uuid: Command.uuid,
                                value: Data(),
                                permissions: [.write],
                                properties: [.write],
                                descriptors: notifyDescriptors)
        ]
        
        let service = GATT.Service(uuid: LockService.uuid,
                                   primary: true,
                                   characteristics: characteristics)
        
        self.serviceHandle = try peripheral.add(service: service)
        self.commandHandle = peripheral.characteristics(for: Command.uuid)[0]
        
        let pwms = SwiftyGPIO.hardwarePWMs(for: .RaspberryPi3)!
        let pwm = (pwms[0]?[.P18])!
        self.servoMotor = ServoMotor(pwm)
    }
    
    deinit {
        self.peripheral.remove(service: serviceHandle)
    }
    
    // MARK: - Methods
    
    public func willRead(_ request: GATTReadRequest) -> ATT.Error? {
        
        return nil
    }
    
    public func willWrite(_ request: GATTWriteRequest) -> ATT.Error? {
        
        return nil
    }
    
    public func didWrite(_ write: GATTWriteConfirmation) {
        
        switch write.uuid {
        case Command.uuid:
            handleCommand(write)
            
        default:
            break
        }
    }
    
    private func handleCommand(_ write: GATTWriteConfirmation) {
        
        guard let command = Command(data: write.value) else {
            print("Invalid data received"); return
        }
        
        switch command {
        case .open:
            servoMotor?.move(to: .left)
            print("open")
            
        case .close:
            servoMotor?.move(to: .right)
            print("close")
        }
    }
}
