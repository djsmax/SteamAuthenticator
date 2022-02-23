//
//  HMACAlgorithm.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 22.02.22.
//

import Foundation

import CryptoKit

let secretString = "my-secret"
let key = SymmetricKey(data: secretString.data(using: .utf8)!)

let string = "An apple a day keeps anyone away, if you throw it hard enough"

let signature = HMAC<SHA256>.authenticationCode(for: Data(string.utf8), using: key)
print(Data(signature).map { String(format: "%02hhx", $0) }.joined()) // 1c161b971ab68e7acdb0b45cca7ae92d574613b77fca4bc7d5c4effab89dab67
