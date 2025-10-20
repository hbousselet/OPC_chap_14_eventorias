//
//  AuthFirebaseMock.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 19/10/2025.
//

import Foundation
import FirebaseAuth
import Firebase
@testable import OPC_Chap14_Eventorias

final class AuthFirebaseMock: AuthFirebaseProtocol {
    var isAuthenticated: Bool = false
    var currentUser: FirebaseAuth.User? = nil
    var shouldSuccess: Bool = true
    
    
    func signIn(email: String, password: String) async throws {
        if shouldSuccess {
            isAuthenticated = true
        } else {
            throw EventoriasAlerts.notAbleToSignIn
        }
    }
    
    func createUser(email: String, password: String) async throws {
        if shouldSuccess {
            isAuthenticated = true
        } else {
            throw EventoriasAlerts.notAbleToSignUp
        }
    }
}
