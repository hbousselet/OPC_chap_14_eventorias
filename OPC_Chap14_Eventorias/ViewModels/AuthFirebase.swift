//
//  AuthFirebase.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 25/09/2025.
//

import Foundation
import FirebaseAuth

@Observable class AuthFirebase {
    var isAuthenticated: Bool = Auth.auth().currentUser != nil
    
    var email: String {
        Auth.auth().currentUser?.email ?? "default_user"
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
        } catch {
            print("Error at signout: \(error)")
        }
    }

}
