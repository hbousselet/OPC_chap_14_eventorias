//
//  SignInViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor
@Observable class AuthtenticationViewModel {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var isAuthenticated: Bool = false
    var error: Error?
    
    func signIn() async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            print("On vient de se log ma gueule")
            isAuthenticated = true
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func signUp() async {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            print("On vient de créer un compte mon gars")
            try await populateUserInDb()
            isAuthenticated = true
        } catch {
            self.error = error
            print(error)
        }
    }
    
    func populateUserInDb() async throws {
        let user = User(name: name,
                        email: email,
                        icon: nil,
                        notification: false)
        if let currentAuthUser = Auth.auth().currentUser {
            try await user.populateUser(currentAuthUser.uid)
        }
    }
}
