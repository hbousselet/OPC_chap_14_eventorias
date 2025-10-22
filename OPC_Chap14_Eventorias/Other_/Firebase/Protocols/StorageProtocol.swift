//
//  StorageProtocol.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 22/10/2025.
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
    func downloadURL() async throws -> URL
    var storageReference: StorageReference { get set }
}
