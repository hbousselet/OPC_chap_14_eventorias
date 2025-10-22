//
//  User.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 24/09/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct UserFirestore: Codable, Equatable, Hashable {
    var name: String
    var email: String
    let icon: URL?
    var notification: Bool
}

extension UserFirestore {
    func populateUser(_ documentId: String, firestoreService: FirestoreProtocol = FirestoreService(collection: "User")) async throws {
        do {
            try await firestoreService.document(documentId).setData([
                "name": name,
                "email": email,
                "icon": icon ?? "",
                "notification": notification
            ])
        } catch {
            throw error
        }
    }
    
    static func fetchUser(_ userId: String, firestoreService: FirestoreProtocol = FirestoreService(collection: "User")) async throws -> Self {
        do {
            let docRef = firestoreService.document(userId)

            let document = try await docRef.getDocument()
            if document.exists {
                let user = try document.data(as: UserFirestore.self)
                return user
            } else {
                throw EventoriasAlerts.userDoesNotExist
            }
        } catch {
            throw EventoriasAlerts.notAbleToFetchUser
        }
    }
}
