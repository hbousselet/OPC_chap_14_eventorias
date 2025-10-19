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
    func logout()
}

@Observable class AuthFirebase: AuthFirebaseProtocol {
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
    
    func logout() { // dev purpose
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error at signout: \(error)")
        }
    }

}
