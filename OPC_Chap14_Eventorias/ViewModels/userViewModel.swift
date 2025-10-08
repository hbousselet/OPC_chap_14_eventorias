//
//  userViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 05/10/2025.
//

import Foundation
import FirebaseAuth

@Observable class UserViewModel {
    var user: User
    
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
            print("User in error: \(error)")
        }
    }
    
    func updateUser() async {
        
    }
    
    // TODO: implement this method
    func toggleNotifications(value: Bool) async {
        
    }
}
