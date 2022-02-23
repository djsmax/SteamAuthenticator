//
//  SteamUser.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 19.02.22.
//

import Foundation

class SteamUser: Identifiable {
    var accountName: String
    var sharedSecret: String
    
    init(accountName: String, sharedSecret: String) {
        self.accountName = accountName
        self.sharedSecret = sharedSecret
    }
}
