//
//  StorageEventorias.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 20/10/2025.
//

import Foundation
import FirebaseStorage

protocol StorageProtocol {
    func child(_ path: String)
    func putDataAsync(
        _ uploadData: Data,
        metadata: StorageMetadata?,
        onProgress: ((Progress?) -> Void)?
    ) async throws -> StorageMetadata
    var storageReference: StorageReference { get set }
}

class StorageEventorias: StorageProtocol {
    func child(_ path: String) {
        storageReference = reference.child(path)
    }
    
    let reference = Storage.storage().reference()
    
    var storageReference: StorageReference
    
    func putDataAsync(
        _ uploadData: Data,
        metadata: StorageMetadata? = nil,
        onProgress: ((Progress?) -> Void)? = nil
    ) async throws -> StorageMetadata {
        try await storageReference.putDataAsync(uploadData, metadata: metadata, onProgress: nil)
    }
    
    init(path: String = "") {
        self.storageReference = reference.child(path)
    }
}
