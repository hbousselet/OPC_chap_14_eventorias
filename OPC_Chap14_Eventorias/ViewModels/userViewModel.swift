//
//  userViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 05/10/2025.
//

import Foundation
import FirebaseAuth

protocol UserProtocol {
    func fetchUser() async
}

@Observable class UserViewModel: UserProtocol {
    var user: User
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts? = Optional.none
    
    init() {
        let currentUser = Auth.auth().currentUser
        user = User(name: "",
                    email: currentUser?.email ?? "",
                    icon: nil,
                    notification: false)
    }
    
    func fetchUser() async {
        do {
            user = try await User.fetchUser(Auth.auth().currentUser!.uid)
        } catch {
            alertIsPresented = true
            alert = .notAbleToFetchUser(error: error)
        }
    }
}
