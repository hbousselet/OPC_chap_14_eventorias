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
    var currentUser: FirebaseAuth.User? { get }
    func signOut()
    func signIn(email: String, password: String) async throws
    func createUser(email: String, password: String) async throws
}

@Observable class AuthFirebase: AuthFirebaseProtocol {
    var currentUser: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    var currentUserId: String?
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
            throw error
        }
    }
    
    func createUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw error
        }
    }
    
    
    func signOut() { // dev purpose
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error at signout: \(error)")
        }
    }

}
