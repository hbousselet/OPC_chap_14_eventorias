//
//  AuthFirebase.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 25/09/2025.
//

import Foundation
import FirebaseAuth

protocol AuthFirebaseProtocol {
    var isAuthenticated: Bool { get }
    var currentUser: AuthUser? {get}
    func signIn(email: String, password: String) async throws
    func createUser(email: String, password: String) async throws
}

@Observable class FirebaseService: AuthFirebaseProtocol {
    private var auth = Auth.auth()
    var currentUser: AuthUser? {
        return auth.currentUser
    }
    
    var isAuthenticated: Bool = Auth.auth().currentUser != nil
            
    init() {
        let _ = Auth.auth().addStateDidChangeListener { (_, user) in
            if user == nil {
                self.isAuthenticated = false
            } else {
                self.isAuthenticated = true
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw EventoriasAlerts.notAbleToSignIn
        }
    }
    
    func createUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw EventoriasAlerts.notAbleToSignUp
        }
    }
    
    func signOut() { // dev purpose
        do {
            try auth.signOut()
            isAuthenticated = false
        } catch {
            print("Error at signout: \(error)")
        }
    }
}

protocol AuthCusto {
    
}
