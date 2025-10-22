//
//  FirestoreFirebaseMock.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import Foundation
import Firebase
@testable import OPC_Chap14_Eventorias

final class FirestoreServiceMock: DBAccessProtocol {
    var dbService = FirestoreMock()
    
    var shouldSuccess: Bool = true
    var data: Data?
    
    func create(data: [String : Any], to id: String?) async throws -> String? {
        return nil
    }
    
    func multipleFetch<T>() async throws -> [T] where T : Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if shouldSuccess {
            return try decoder.decode(Array<T>.self, from: data!)
        } else {
            throw EventoriasAlerts.failedMultiFetch
        }
    }
    
    func uniqueFetch<T: Decodable & IdentifiableByString>(id: String) async throws -> T where T : Decodable {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        if shouldSuccess {
            let decodedData = try decoder.decode([T].self, from: data!)
            return decodedData.first(where: { $0.identifier == id })!
//            return try decoder.decode(T.self, from: data!)
        } else {
            throw EventoriasAlerts.failedFetch
        }
    }
}

final class FirestoreMock { }
