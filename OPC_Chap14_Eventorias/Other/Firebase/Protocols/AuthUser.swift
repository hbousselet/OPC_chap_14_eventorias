//
//  AuthUserProtocol.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import Foundation
import FirebaseAuth

protocol AuthUserProtocol {
    var uid: String {get}
    var displayName: String? {get}
    var email: String? {get}
    var photoURL: URL? {get}
}

extension FirebaseAuth.User : AuthUserProtocol {}
