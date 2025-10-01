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
    let icon: URL?
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
    
    static func fetchUser(_ userId: String) async throws -> Self {
        do {
            let db = Firestore.firestore()
            let docRef = db.collection("User").document(userId)

            
            let document = try await docRef.getDocument()
            if document.exists {
                let user = try document.data(as: User.self)
                return user
            } else {
                throw CocoaError(.fileReadNoSuchFile) // to be changed
            }
        } catch {
            print("Error getting documents: \(error)")
            throw error
        }
    }
}
