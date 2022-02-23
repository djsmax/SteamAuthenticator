//
//  Helper.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 23.02.22.
//

import Foundation

class Helper: ObservableObject {
    var currentAccount: SteamUser?
    @Published var codeField: String = ""
    @Published var accountNameField: String = ""
    

    func updateCode() {
        guard let account: SteamUser = currentAccount else {
            // TODO: log
            return
        }
        let code = generateGuardCode(sharedSecret: account.sharedSecret)
        self.codeField = code
    }
    
    func setAccount(account: SteamUser?) {
        self.currentAccount = account
        self.accountNameField = account?.accountName ?? ""
        self.updateCode()
    }
    
    func displayNoAccounts() {
        self.accountNameField = "Oops. No accounts found! Drag and drop one inside here."
    }
    
}
