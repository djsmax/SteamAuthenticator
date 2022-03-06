//
//  AccountStorage.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation

class AccountStorage {
    let preferences = UserDefaults.standard
    var accounts: [SteamUser] = []
    
    init() {
        load()
    }
    
    func load() {
        if let savedPerson = self.preferences.object(forKey: "accounts") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([SteamUser].self, from: savedPerson) {
                self.accounts = loadedPerson
            }
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.accounts) {
            self.preferences.set(encoded, forKey: "accounts")
        }
    }
    
    func getSavedAccounts() -> [SteamUser] {
        return self.accounts
    }
    
    func add(user: SteamUser) {
        self.accounts.append(user)
        self.save()
    }
}
