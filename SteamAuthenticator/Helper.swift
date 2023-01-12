//
//  Helper.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation

class Helper: ObservableObject {
    let preferences = UserDefaults.standard
    var currentAccount: SteamUser?
    @Published var codeField: String = ""
    @Published var accountNameField: String = ""
    
    
    func updateCode() {
        guard let account: SteamUser = currentAccount else {
            return
        }
        let code = generateGuardCode(sharedSecret: account.sharedSecret)
        self.codeField = code
    }
    
    func getLastUsedAccountName() -> String? {
        preferences.string(forKey: "lastUsedAccount")
    }
    
    func setAccount(_ account: SteamUser?) {
        self.currentAccount = account
        self.accountNameField = account?.accountName ?? ""
        self.updateCode()
        preferences.set(self.accountNameField, forKey: "lastUsedAccount")
    }
    
    func displayNoAccounts() {
        self.accountNameField = "Oops. No accounts found! Drag and drop one inside here."
    }
    
}
