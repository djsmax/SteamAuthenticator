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
            Text(helper.accountNameField).frame(maxWidth: .infinity, alignment: .leading).padding(4).font(.body.weight(Font.Weight.bold))
            TextField("",text: $helper.codeField).font(.title)
            Spacer()
            List (accounts) { steamUser in
                Button (action: {
                    helper.setAccount(account: steamUser)
                    helper.updateCode()
                }) {
                    SteamUserRow(user: steamUser)
                }
            }.onDrop(of: ["public.url","public.file-url"], isTargeted: nil) { (items) -> Bool in
                if let item = items.first {
                    if let identifier = item.registeredTypeIdentifiers.first {
                        if identifier == "public.url" || identifier == "public.file-url" {
                            item.loadItem(forTypeIdentifier: identifier, options: nil) { (urlData, error) in
                                DispatchQueue.main.async {
                                    if let urlData = urlData as? Data {
                                        let absoluteUrl = NSURL(absoluteURLWithDataRepresentation: urlData, relativeTo: nil) as URL
                                        // read JSON
                                        let steamUser = readCodeFromFile(url: absoluteUrl)
                                        // put it into storage
                                        if (steamUser == nil) {
                                            // TODO: show an error box
                                            return
                                        }
                                        accountStorage.add(user: steamUser!)
                                        // TODO: refresh to display
                                    }
                                }
                            }
                        }
                    }
                    return true
                } else {
                    return false
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
