//
//  ChunkCharacteristic.swift
//  CoreServer
//
//  Created by Carlos Duclos on 8/5/18.
//

import Foundation
import Bluetooth
import GATT

public protocol ChunkCharacteristic: GATTProfileCharacteristic {
    
    associatedtype Value
    
    static func from(chuks: [Self]) -> Value?
    static func from(_ value: Value, maximumUpdateValueLength: Int) -> [Self]
    
    var chunk: Chunk { get }
    init(chunk: Chunk)
}

public struct Chunk {
    
    internal static let length = MemoryLayout<UInt32>.size + MemoryLayout<UInt8>.size
    
    public var isFirst: Bool
    public var total: UInt32
    public var bytes: Data
    
    internal init(isFirst: Bool, total: UInt32, bytes: Data) {
        
        self.isFirst = isFirst
        self.total = total
        self.bytes = bytes
    }
    
    public init?(data: Data) {
        
        guard data.count >= type(of: self).length else { return nil }
        guard let isFirst = Bool(byteValue: data[0]) else { return nil }
        
        self.isFirst = isFirst
        self.total = UInt32(littleEndian: UInt32(bytes: (data[1], data[2], data[3], data[4])))
        self.bytes = Data(data.dropFirst(type(of: self).length))
    }
    
    public var data: Data {
        
        let totalBytes = total.littleEndian.bytes
        
        return [isFirst.byteValue,
                totalBytes.0,
                totalBytes.1,
                totalBytes.2,
                totalBytes.3] + bytes
    }
    
    /// Prepare data to send in chunks that can be sent via notifications.
    public static func from(_ data: Data, maximumUpdateValueLength: Int) -> [Chunk] {
        
        // If the attribue value is longer than (ATT_MTU-3) octets,
        // then only the first (ATT_MTU-3) octets of this attribute value
        // can be sent in a notification.
        let chunkSize = maximumUpdateValueLength - length
        
        let chunkData: [Data] = stride(from: 0, to: data.count, by: chunkSize).map {
            Data(data[$0 ..< min($0 + chunkSize, data.count)])
        }
        
        let totalBytes = UInt32(data.count)
        
        return chunkData.enumerated().map {
            Chunk(isFirst: $0.offset == 0, total: totalBytes, bytes: $0.element)
        }
    }
}
