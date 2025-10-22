//
//  DBAccessProtocol.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 22/10/2025.
//

import Foundation

//used for Firestore only
protocol DBAccessProtocol {
    associatedtype DBService
    var dbService: DBService { get }
    
    func create(data: [String : Any], to id: String?) async throws -> String?
    func multipleFetch<T: Decodable>() async throws -> [T]
    func uniqueFetch<T: Decodable>(id: String) async throws -> T
}
