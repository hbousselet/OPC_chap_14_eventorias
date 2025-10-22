//
//  FirestoreService.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 20/10/2025.
//

import Foundation
import FirebaseFirestore

class FirestoreService: DBAccessProtocol {
    var dbService: Firestore = Firestore.firestore()
    typealias DBService = Firestore
    
    var collection: String
    
    init(collection: String,) {
        self.collection = collection
    }
    
    func create(data: [String : Any], to id: String? = nil) async throws -> String? {
        do {
            if let id {
                try await dbService.collection(collection).document(id).setData(data)
                return nil
            } else {
                let newDocumentRef = try await dbService.collection(collection).addDocument(data: data)
                return newDocumentRef.documentID
            }
        } catch {
            throw EventoriasAlerts.failedCreate
        }
    }
    
    func multipleFetch<T: Decodable>() async throws -> [T] {
        var finalT: [T] = []
        do {
            let fetchedT = try await dbService.collection(collection).getDocuments()
            for element in fetchedT.documents {
                let decodedElement = try element.data(as: T.self)
                finalT.append(decodedElement)
            }
            return finalT
        } catch {
            throw EventoriasAlerts.failedMultiFetch
        }
    }
    
    func uniqueFetch<T: Decodable>(id: String) async throws -> T {
        let documentReference = dbService.collection(collection).document(id)
        do {
            return try await documentReference.getDocument(as: T.self)
        } catch {
            throw EventoriasAlerts.failedFetch
        }
    }
}
