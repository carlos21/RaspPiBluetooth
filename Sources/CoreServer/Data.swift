//
//  Data.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/5/18.
//

import Foundation

extension Data {
    
    struct HexEncodingOptions: OptionSet {
        let rawValue: Int
        static let upperCase = HexEncodingOptions(rawValue: 1 << 0)
    }
    
    func hexEncodedString(options: HexEncodingOptions = []) -> String {
        let format = options.contains(.upperCase) ? "%02hhX" : "%02hhx"
        return map { "0x" + String(format: format, $0) + ", " }.joined()
    }
}
