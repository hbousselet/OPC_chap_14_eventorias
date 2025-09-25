//
//  User.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 24/09/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct User: Codable {
    let name: String
    let email: String
    let icon: String?
    let notification: Bool
}

extension User {
    func populateUser(_ documentId: String) async throws {
        do {
            let db = Firestore.firestore()
            try await db.collection("User").document(documentId).setData([
                "name": name,
                "email": email,
                "icon": icon ?? "",
                "notification": notification
            ])
        } catch {
            print("Error getting documents: \(error)")
            throw error
        }
    }
}
