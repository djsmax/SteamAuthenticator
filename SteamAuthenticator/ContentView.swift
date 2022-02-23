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
        Text("\(user.accountName)")
    }
}

struct ContentView: View {
    @State private var authCodeText = "some auth code"
    let accounts = [
        SteamUser(accountName: "mySteamAccount", sharedSecret: "lel"),
        SteamUser(accountName: "secondSteamAccount", sharedSecret: "lel"),
        SteamUser(accountName: "actualSteamAccount", sharedSecret: "lel"),
        
    ]
    
    
    var body: some View {
        VStack {
            TextField("lol",text: $authCodeText)
            List(accounts) { steamUser in
                SteamUserRow(user: steamUser)
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
