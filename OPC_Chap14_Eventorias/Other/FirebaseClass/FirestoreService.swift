//
//  FirestoreService.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 20/10/2025.
//

import Foundation
import FirebaseFirestore

protocol FirestoreProtocol {
    func getDocuments() async throws -> QuerySnapshot
    func setData(_ documentData: [String : Any]) async throws
    func document(_ documentPath: String) -> DocumentReference
    func addDocument(data: [String : Any]) async throws -> DocumentReference
}

class FirestoreService: FirestoreProtocol {
    func getDocuments() async throws -> QuerySnapshot {
        return try await db.collection(collection).getDocuments()
    }
    
    func setData(_ documentData: [String : Any]) async throws {
        return try await db.collection(collection).document(documentId).setData(documentData)
    }
    
    func document(_ documentPath: String) -> DocumentReference {
        return db.collection(collection).document(documentPath)
    }
    
    func addDocument(data: [String : Any]) async throws -> DocumentReference {
        return try await db.collection(collection).addDocument(data: data)
    }
    
    private let db = Firestore.firestore()
    var collection: String
    var documentId: String = ""
    
    init(collection: String) {
        self.collection = collection
    }
}
