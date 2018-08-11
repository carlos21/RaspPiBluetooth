//
//  ServoMotor.swift
//  RaspPiBluetooth
//
//  Created by Carlos Duclos on 8/8/18.
//
//

import Foundation
import SwiftyGPIO

let SERVO_PERIOD_NS = 20_000_000  //20ms

public struct ServoMotor {
    
    var pwm: PWMOutput
    
    public init(_ pwm: PWMOutput, period: Int = SERVO_PERIOD_NS) {
        self.pwm = pwm
    }
    
    public func enable() {
        pwm.initPWM()
    }
    
    public func disable() {
        pwm.stopPWM()
    }
    
    public func move(to: Position) {
        pwm.startPWM(period: SERVO_PERIOD_NS, duty: Float(to.rawValue))
    }
}

public extension ServoMotor {
    
    public enum Position: Int {
        
        case left = 5
        case middle = 8
        case right = 12
    }
}

