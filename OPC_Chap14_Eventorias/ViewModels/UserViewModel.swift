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
    var user: UserFirestore
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts? = Optional.none
    var firebase: AuthFirebaseProtocol
    let firestore: any DBAccessProtocol
    
    init(firebase: AuthFirebaseProtocol = FirebaseService(),
         firestore: any DBAccessProtocol = FirestoreService(collection: "User")) {
        self.firebase = firebase
        self.firestore = firestore
        self.user = UserFirestore(name: "",
                    email: firebase.currentUser?.email ?? "",
                    icon: nil,
                    notification: false)
    }
    
    func fetchUser() async {
        do {
            guard let userid = firebase.currentUser?.uid else {
                alertIsPresented = true
                alert = .userDoesNotExist
                return
            }
            user = try await UserFirestore.fetchUser(userid, firestoreService: firestore)
        } catch {
            alertIsPresented = true
            alert = .notAbleToFetchUser
        }
    }
}
