//
//  FileReader.swift
//  SteamAuthenticator
//
//  Created by Max Denwer on 06.03.22.
//

import Foundation

func readCodeFromFile(url: URL) -> SteamUser? {
    do {
        let rawData = try Data(contentsOf: url, options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: rawData, options: .mutableLeaves)
        let accountJson = jsonResult as! Dictionary<String, AnyObject>
        // read account name and shared secret
        let account_name = accountJson["account_name"] as? String ?? ""
        let shared_secret = accountJson["shared_secret"] as? String ?? ""
        let steamUser = SteamUser(accountName: account_name, sharedSecret: shared_secret)
        return steamUser
    } catch {
        print("failed to read as JSON")
        // TODO: show error message
    }
    return nil
}
