//
//  AccountStorage.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation

class AccountStorage: ObservableObject {
    let preferences = UserDefaults.standard
    @Published var accounts: [SteamUser] = []
    
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
    
    func add(user: SteamUser) -> Bool {
        if self.accounts.contains(where: {$0.accountName == user.accountName}) {
            return false
        }
        self.accounts.append(user)
        objectWillChange.send()
        self.save()
        return true
    }
    
    func remove(accountName: String) {
        self.accounts.removeAll{$0.accountName == accountName}
        self.save()
    }
}
