//
//  EventoriasUser.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 24/09/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct EventoriasUser: Codable, Equatable, Hashable, IdentifiableByString {
    var name: String
    var email: String
    let icon: URL?
    var notification: Bool
    var identifier: String?
}

protocol IdentifiableByString {
    var identifier: String? { get }
}

extension EventoriasUser {
    func populateUser(_ documentId: String, firestoreService: any DBAccessProtocol) async throws {
        do {
            let _ = try await firestoreService.create(data: [
                "name": name,
                "email": email,
                "icon": icon ?? "",
                "notification": notification
            ], to: documentId)
        } catch {
            throw error
        }
    }
    
    static func fetchUser(_ userId: String, firestoreService: any DBAccessProtocol) async throws -> Self {
        do {
            return try await firestoreService.uniqueFetch(id: userId)
        } catch {
            throw EventoriasAlerts.notAbleToFetchUser
        }
    }
}
