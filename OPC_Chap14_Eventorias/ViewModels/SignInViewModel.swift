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
@Observable class SignInViewModel {
    var email: String = ""
    var password: String = ""
    var isAuthenticated: Bool = false
    var error: Error?
    
    func signIn() async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            isAuthenticated = true
            print("On vient de se log ma gueule")
        } catch {
            self.error = error
            print(error)
        }
    }
}
