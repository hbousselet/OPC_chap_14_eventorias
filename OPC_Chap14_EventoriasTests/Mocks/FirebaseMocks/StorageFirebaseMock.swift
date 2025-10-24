//
//  StorageFirebaseMock.swift
//  OPC_Chap14_EventoriasTests
//
//  Created by Hugues BOUSSELET on 21/10/2025.
//

import Foundation
import FirebaseStorage
@testable import OPC_Chap14_Eventorias


class StorageFirebaseMock: StorageProtocol {
    var shouldSuccess: Bool = true
    var data: Data? = nil
    var url: URL? = nil

    func child(_ path: String) { }
    
    func putDataAsync(_ uploadData: Data, metadata: FirebaseStorage.StorageMetadata?, onProgress: ((Progress?) -> Void)?) async throws -> FirebaseStorage.StorageMetadata {
        if shouldSuccess {
            return FirebaseStorage.StorageMetadata(dictionary: ["test": "coucou"])
        } else {
            throw EventoriasAlerts.notAbleToExportImage
        }
    }
    
    func downloadURL() async throws -> URL {
        if shouldSuccess {
            return url!
        } else {
            throw EventoriasAlerts.imageUrlNotFound
        }
    }
    
    var storageReference: FirebaseStorage.StorageReference = Storage.storage().reference(withPath:"test")
    
    
}
