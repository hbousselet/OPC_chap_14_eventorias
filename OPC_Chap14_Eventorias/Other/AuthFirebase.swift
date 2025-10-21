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
    var user: UserFirebase? { get }
    func signIn(email: String, password: String) async throws
    func createUser(email: String, password: String) async throws
}

@Observable class AuthFirebase: AuthFirebaseProtocol {
    var user: UserFirebase?
    
    var isAuthenticated: Bool = Auth.auth().currentUser != nil
            
    init() {
        let _ = Auth.auth().addStateDidChangeListener { (_, user) in
            if user == nil {
                self.isAuthenticated = false
            } else {
                self.isAuthenticated = true
                self.user = try? self.createFirebaseUser()
            }
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
            user = try createFirebaseUser()
        } catch {
            throw EventoriasAlerts.notAbleToSignIn
        }
    }
    
    func createUser(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            user = try createFirebaseUser()
        } catch {
            throw EventoriasAlerts.notAbleToSignUp
        }
    }
    
    func createFirebaseUser() throws -> UserFirebase {
        guard let user = Auth.auth().currentUser,
        let email = Auth.auth().currentUser?.email else {
            throw EventoriasAlerts.notAbleToSignUp
        }
        
        return UserFirebase(email: email, uid: user.uid)
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

struct UserFirebase {
    var email: String
    var uid: String
}
