//
//  GenLogic.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 19.02.22.
//

import Foundation
import CryptoKit


func currTime() -> UInt32 {
    // get local Unix time in seconds
    return UInt32(Date().timeIntervalSince1970)
}


func generateGuardCode(sharedSecret: String) -> String {
    guard let secret = sharedSecret.fromBase64() else { return "" }
    let timeOffset = currTime() / 30
    // construct an 8 byte buffer; all 8 bytes are zeroed by default?
    var buffer = Data(count: 8)
    // write time as uint32 into the last 4 bytes
    buffer.writeUInt32BE(value: timeOffset, offset: 4)
    
    // use SHA-1 HMAC with newly made buffer and sharedSecret as a key
    var hmacGen = HMAC<Insecure.SHA1>(key: SymmetricKey(data: secret))
    hmacGen.update(data: buffer)
    let hmac = Data(hmacGen.finalize())
    // something happens here..
    let start = Int(hmac[19] & 0x0F)
    var fullcode = UInt32(hmac.readUInt32BE(offset: start))
    fullcode = fullcode & 0x7FFFFFFF
    // convert it into human-readable code
    let chars = "23456789BCDFGHJKMNPQRTVWXY";
    
    var code = "";
    for _ in 0...4 {
        let someCount = fullcode % UInt32(chars.count)
        code += chars[Int(someCount)]
        fullcode /= UInt32(chars.count)
    }
    
    return code
}
				
