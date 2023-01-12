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
    var accountStorage = AccountStorage()
    var currentAccount: SteamUser? = nil
    @State var copiedTextShown = false
    @State var countdown: Float = Float(timeOffset())
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var showRemoveAccountAlert = false
    @State private var showDuplicateAccountAlert = false
    @State var chosenAccountToRemove: String = ""
    
    
    
    init() {
        if (accountStorage.accounts.count >= 1) {
            if let lastAccountName = self.helper.getLastUsedAccountName() {
                if let lastAccount = accountStorage.accounts.first(where: {$0.accountName == lastAccountName}) {
                    helper.setAccount(lastAccount)
                } else {
                    helper.setAccount(accountStorage.accounts[0])
                }
            }
        } else {
            helper.displayNoAccounts()
        }
    }
    
    
    
    
    var body: some View {
        VStack {
            HStack {
                Text(helper.accountNameField)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if (copiedTextShown) {
                    Label("Copied!", systemImage: "checkmark.circle")
                        .foregroundColor(.green)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .transition(.move(edge: .trailing))
                }
            }
            .padding(4)
            .font(.body.weight(Font.Weight.bold))
            ZStack(alignment: .trailing) {
                TextField("",text: $helper.codeField).font(.title)
                Button {
                    copyToClipboard()
                } label: {
                    Image(systemName: "doc.on.clipboard")
                }
                .padding(.trailing, 8)
            }
            .padding(.horizontal, 4)
            
            
            ProgressView(value: countdown, total: 30)
                .padding(.horizontal, 4)
                .onReceive(timer) { time in
                    countdown -= 1
                    if (countdown == 0) {
                        helper.updateCode()
                        self.countdown = 30
                    }
                }
            Spacer()
            
            List (accountStorage.accounts) { steamUser in
                HStack {
                    Button (action: {
                        helper.setAccount(steamUser)
                        helper.updateCode()
                    }) {
                        SteamUserRow(user: steamUser)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Button(role: .destructive) {
                        self.chosenAccountToRemove = steamUser.accountName
                        showRemoveAccountAlert.toggle()
                    } label: {
                        Text("x")
                            .foregroundColor(.red)
                            .frame(alignment: .trailing)
                    }
                }
                
            }
            .onDrop(of: ["public.url","public.file-url"], isTargeted: nil) { (items) -> Bool in
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
                                        if (!accountStorage.add(user: steamUser!)) {
                                            showDuplicateAccountAlert.toggle()
                                            return
                                        }
                                        // self.accounts = accountStorage.getSavedAccounts()
                                        helper.setAccount(steamUser!)
                                        helper.updateCode()
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
        .alert(isPresented: $showRemoveAccountAlert) {
            Alert(
                title: Text("Remove account"),
                message: Text("Delete **\(chosenAccountToRemove)**?\nThere is no recycle bin!"),
                primaryButton: .cancel(Text("Cancel")),
                secondaryButton: .destructive(Text("Delete")) {
                    accountStorage.remove(accountName: chosenAccountToRemove)
                }
            )
        }
        .alert("Account with this name already exists.\nPlease, check the list or change its login.", isPresented: $showDuplicateAccountAlert) {
            Button("Got it, will do", role: .cancel) { }
        }
    }
    
    
    func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(helper.codeField, forType: .string)
        
        withAnimation {
            self.copiedTextShown = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.copiedTextShown = false
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
