//
//  AuthFirebaseProtocol.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 22/10/2025.
//

import Foundation

protocol AuthFirebaseProtocol {
    var isAuthenticated: Bool { get }
    var currentUser: AuthUserProtocol? {get}
    func signIn(email: String, password: String) async throws
    func createUser(email: String, password: String) async throws
}
