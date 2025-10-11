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

@Observable class EventCreationViewModel {
    var title: String = ""
    var description: String = ""
    var date: String = ""
    var time: String = ""
    var address: String = ""
    var addressEnteredRequested: MKMapItem?
    var imageName: String = ""
    var selectedImage: Data?
    var alertIsPresented: Bool = false
    var alert: EventCreationAlert = .none
    var dismiss: Bool = false
    var type: EventType?
    
    var getCurrentUserId: String {
        Auth.auth().currentUser?.uid ?? ""
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
            await turnAddressToLocation()
            try await uploadEvent(with: date)
            await exportImagev2()
        } catch {
            print("Error blabla: \(error)")
        }
    }
    
    private func uploadEvent(with date: Date) async throws {
        let event: [String : Any] = [
            "name": title,
            "description": description,
            "address": GeoPoint(latitude: addressEnteredRequested?.location.coordinate.latitude ?? 48.8575, longitude: addressEnteredRequested?.location.coordinate.longitude ?? 2.3514),
            "date": date,
            "user": getCurrentUserId,
            "image": title.removeSpacesAndLowercase()
        ]
        do {
            let db = Firestore.firestore()
            try await db.collection("Event").addDocument(data: event)
            
        } catch {
            print("Error adding document: \(error)")
            throw error
        }
    }
    
    private func turnAddressToLocation() async {
        if let request = MKGeocodingRequest(addressString: address) {
            do {
                let mapitems = try await request.mapItems
                if let mapitem = mapitems.first {
                    addressEnteredRequested = mapitem
                    print("we found the following location: \(String(describing: addressEnteredRequested?.location.coordinate))")
                }
            } catch let error {
                print("error: \(error)")
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
    
    private func exportImagev2() async {
        guard let selectedImage,
        let uiImage = UIImage(data: selectedImage),
        let compressedData = uiImage.jpegData(compressionQuality: 0.5) else { return }
        let imageRef = Storage.storage().reference().child("images/\(title.removeSpacesAndLowercase()).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let _ = try await imageRef.putDataAsync(compressedData, metadata: metadata)
        } catch {
            print("Error: \(error)")
        }
    }
}

enum EventCreationAlert: String {
    case none
    case invalidDate = "You entered an invalid date. Please try again."
    case emptyDate = "No date was entered. Please enter a date"
    case emptyTitle = "Please enter a title"
    case emptyDescription = "Please enter a description"
    case emptyAddress = "Please enter an address"
    case invalidAddress = "The address you entered was not found. Please try again."
}



//func exportImage() {
//        guard let selectedImage else { return }
//        let imageRef = Storage.storage().reference().child("images/\(title.removeSpacesAndLowercase()).jpg")
//        let uploadTask = imageRef.putData(selectedImage, metadata: nil) { (metadata, error) in
//            guard let metadata = metadata else {
//                print(error)
//                return
//            }
//        }
//    }
