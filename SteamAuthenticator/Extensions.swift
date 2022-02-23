//
//  Extensions.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation


extension String {
    // thanks to nalexn
    // https://stackoverflow.com/a/26775912
    
    func fromBase64() -> Data? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return data
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
}

extension Data {
    
    
    func readUInt32BE(offset: Int = 0) -> UInt32 {
        return (
            (UInt32(self[offset]) << 24) |
            (UInt32(self[offset + 1]) << 16) |
            (UInt32(self[offset + 2]) << 8) |
            UInt32(self[offset + 3])
        )
    }
    
    
    mutating func writeUInt32BE(value: UInt32, offset: Index = 0) {
        self[offset] = UInt8((value & 0xff000000) >> 24)
        self[offset + 1] = UInt8((value & 0x00ff0000) >> 16)
        self[offset + 2] = UInt8((value & 0x0000ff00) >> 8)
        self[offset + 3] = UInt8(value & 0x000000ff)
    }
}
