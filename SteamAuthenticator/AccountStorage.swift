//
//  AccountStorage.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation

class AccountStorage {
    var preferences = UserDefaults.standard
    var accounts: [SteamUser]? = nil
    
    init() {
        accounts = self.preferences.object(forKey: "accounts") as? [SteamUser]
    }
    
    func getSavedAccounts() -> [SteamUser] {
        return self.accounts ?? []
    }
}
