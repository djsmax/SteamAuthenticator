//
//  SteamAuthenticatorApp.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 19.02.22.
//

import SwiftUI

@main
struct SteamAuthenticatorApp: App {
    init() {
        generateGuardCode(sharedSecret: "something")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
