//
//  UserViewModel.swift
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
    var firebase: AuthFirebaseProtocol
    
    init(firebase: AuthFirebaseProtocol = AuthFirebase()) {
        self.firebase = firebase
        self.user = User(name: "",
                    email: firebase.user?.email ?? "",
                    icon: nil,
                    notification: false)
    }
    
    func fetchUser() async {
        do {
            guard let userid = firebase.user?.uid else {
                alertIsPresented = true
                alert = .userDoesNotExist
                return
            }
            user = try await User.fetchUser(userid)
        } catch {
            alertIsPresented = true
            alert = .notAbleToFetchUser
        }
    }
}
