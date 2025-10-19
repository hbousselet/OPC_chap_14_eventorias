//
//  SignInViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

@MainActor protocol AutenticationProtocol {
    func signIn() async
    func signUp() async
}


@Observable class AuthtenticationViewModel: AutenticationProtocol {
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var isAuthenticated: Bool = false
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts? = Optional.none
    
    func signIn() async {
        guard isValidEmail(email) else {
            alertIsPresented = true
            alert = .invalidEmail
            return
        }
        
        guard !password.isEmpty else {
            alertIsPresented = true
            alert = .emptyPassword
            return
        }
        
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            isAuthenticated = true
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts ?? EventoriasAlerts.notAbleToSignIn(error: error)
            print(error)
        }
    }
    
    func signUp() async {
        do {
            guard isValidEmail(email) else {
                alertIsPresented = true
                alert = .invalidEmail
                return
            }
            guard !name.isEmpty else {
                alertIsPresented = true
                alert = .emptyName
                return
            }
            
            guard !password.isEmpty else {
                alertIsPresented = true
                alert = .emptyPassword
                return
            }
            
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            try await populateUserInDb()
            isAuthenticated = true
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts ?? EventoriasAlerts.notAbleToSignUp
        }
    }
    
    private func populateUserInDb() async throws {
        let user = User(name: name,
                        email: email,
                        icon: nil,
                        notification: false)
        if let currentAuthUser = Auth.auth().currentUser {
            try await user.populateUser(currentAuthUser.uid)
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
