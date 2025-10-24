//
//  EventCreationViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 08/10/2025.
//

import Foundation
import MapKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

protocol EventCreationProtocol {
    func createEvent() async
}

@Observable class EventCreationViewModel {
    var title: String = ""
    var description: String = ""
    var date: String = ""
    var time: String = ""
    var address: String = ""
    var addressEnteredRequested: MKMapItem?
    var selectedImage: Data?
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts = .none
    var dismiss: Bool = false
    var type: EventType?
    
    var createdDocumentId: String?
    
    let firebase: AuthFirebaseProtocol
    let firestore: any DBAccessProtocol
    let storage: StorageProtocol
    
    init(firebase: AuthFirebaseProtocol = FirebaseService(),
         firestore: any DBAccessProtocol = FirestoreService(collection: "Event"),
         storage: StorageProtocol = StorageService()) {
        self.firebase = firebase
        self.firestore = firestore
        self.storage = storage
    }
    
    func createEvent() async {
        guard !title.isEmpty else {
            alertIsPresented = true
            alert = .emptyTitle
            return
        }
        guard !description.isEmpty else {
            alertIsPresented = true
            alert = .emptyDescription
            return
        }
        guard !address.isEmpty else {
            alertIsPresented = true
            alert = .emptyAddress
            return
        }
        guard !date.isEmpty else {
            alertIsPresented = true
            alert = .emptyDate
            return
        }
        guard let date = turnStringToDate() else {
            alertIsPresented = true
            alert = .invalidDate
            return
        }
        do {
            try await turnAddressToLocation()
            try await uploadEvent(with: date)
            try await exportImage()
            dismiss = true
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts ?? .failedEventCreation
        }
    }
    
    private func uploadEvent(with date: Date) async throws {
        let event: [String : Any] = [
            "name": title,
            "description": description,
            "address": GeoPoint(latitude: addressEnteredRequested?.location.coordinate.latitude ?? 48.8575, longitude: addressEnteredRequested?.location.coordinate.longitude ?? 2.3514),
            "date": date,
            "user": firebase.currentUser?.uid ?? "",
            "image": title.removeSpacesAndLowercase(),
            "type": type?.rawValue ?? "other"
        ]
        do {
            createdDocumentId = try await firestore.create(data: event, to: nil)
        } catch {
            throw error
        }
    }
    
    private func turnAddressToLocation() async throws {
        if let request = MKGeocodingRequest(addressString: address) {
            do {
                let mapitems = try await request.mapItems
                if let mapitem = mapitems.first {
                    addressEnteredRequested = mapitem
                }
            } catch {
                alertIsPresented = true
                alert = .invalidAddress
            }
        }
    }
    
    private func turnStringToDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "MM-dd-yy HH:mm"
        return df.date(from: date + " " + time)
    }
    
    private func exportImage() async throws {
        guard let selectedImage,
        let uiImage = UIImage(data: selectedImage),
        let compressedData = uiImage.jpegData(compressionQuality: 0.5) else { return }
        storage.child("images/\(title.removeSpacesAndLowercase()).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let _ = try await storage.putDataAsync(compressedData, metadata: metadata, onProgress: nil)
        } catch {
            alertIsPresented = true
            alert = .notAbleToExportImage
        }
    }
}
