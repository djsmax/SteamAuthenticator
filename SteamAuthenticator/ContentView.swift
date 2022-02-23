//
//  ContentView.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 19.02.22.
//

import SwiftUI


struct SteamUserRow: View {
    var user: SteamUser
    
    var body: some View {
        Text(user.accountName)
    }
}


struct ContentView: View {
    @ObservedObject var helper = Helper()
    let accountStorage = AccountStorage()
    var accounts: [SteamUser] = []
    
    
    init() {
        self.accounts = accountStorage.getSavedAccounts()
        if (self.accounts.count > 1) {
            helper.setAccount(account: self.accounts[0])
        } else {
            helper.displayNoAccounts()
        }

    }

    
    
    var body: some View {
        VStack {
            Text(helper.accountNameField).frame(maxWidth: .infinity, alignment: .leading).padding(4)
            TextField("",text: $helper.codeField).font(.title)
            Spacer()
            List (accounts) { steamUser in
              Button (action: {
                  helper.setAccount(account: steamUser)
                  helper.updateCode()
              }) {
                //How the cell should look
                      SteamUserRow(user: steamUser)
              }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
