#if os(Linux)
import Glibc
import BluetoothLinux
#elseif os(macOS)
import Darwin
import BluetoothDarwin
#endif

import Foundation
import CoreFoundation
import Dispatch
import Bluetooth
import GATT
import SwiftyGPIO

var server: CoreServer?

//let pwms = SwiftyGPIO.hardwarePWMs(for: .RaspberryPi3)!
//let pwm = (pwms[0]?[.P18])!
//
//let s1 = ServoMotor(pwm)
//s1.enable()
//
//for i in 0...10 {
//    print("<- Left")
//    s1.move(to: .left)
//    sleep(1)
//
//    print("^  Middle")
//    s1.move(to: .middle)
//    sleep(1)
//
//    print("-> Right")
//    s1.move(to: .right)
//    sleep(1)
//}
//
//s1.disable()

func run() throws {
    
    guard let hostController = HostController.default else {
        throw ServerError.bluetoothUnavailable
    }
    
    // configure advertising data
    try hostController.setAdvertisingData()
    try hostController.setScanResponse()
    
    #if os(Linux)
    let mtu = ATTMaximumTransmissionUnit(rawValue: 200)!
    let options = LinuxPeripheral.Options(maximumTransmissionUnit: mtu, maximumPreparedWrites: 1000)
    let peripheral = PeripheralManager(controller: hostController, options: options)
    #else
    let peripheral = PeripheralManager()
    #endif
    
    peripheral.log = { print("PeripheralManager: \($0)") }
    
    // wait until XPC connection to blued is established and hardware is on
    #if os(macOS)
    while peripheral.state != .poweredOn { sleep(1) }
    #endif
    
    server = try CoreServer(peripheral: peripheral)
    
    try peripheral.start()
    
    while true {
        #if os(Linux)
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.001, true)
        #elseif os(macOS)
        CFRunLoopRunInMode(.defaultMode, 0.001, true)
        #endif
    }
}

// run
do {
    try run()
} catch {
    print(error)
    exit(EXIT_FAILURE)
}

