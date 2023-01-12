//
//  SteamAuthenticatorApp.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 19.02.22.
//

import SwiftUI

@main
struct SteamAuthenticatorApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                DispatchQueue.main.async {
                    NSApplication.shared.windows.forEach { window in
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                }
            }
        }
    }
}
