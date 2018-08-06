//
//  SensorsProfile.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/4/18.
//

import Foundation

public class SensorsProfile: GATTProfile {
    
    public static let services: [GATTProfileService.Type] = [
        LockService.self
    ]
}
