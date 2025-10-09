//
//  EventCreationViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 08/10/2025.
//

import Foundation
import MapKit
import FirebaseStorage
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
    
    private func turnAddressToLocation() async {
        if let request = MKGeocodingRequest(addressString: address) {
            do {
                let mapitems = try await request.mapItems
                if let mapitem = mapitems.first {
                    addressEnteredRequested = mapitem
                }
            } catch let error {
                print("error: \(error)")
            }
        }
    }
    
    private func turnStringToDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yy-MM-dd HH:mm"
        return df.date(from: date + " " + time)
    }
    
    func exportImage() {
        guard let selectedImage else { return }
        imageName = "test"
        let imageRef = Storage.storage().reference().child("images/\(imageName).jpg")
        let uploadTask = imageRef.putData(selectedImage, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                print(error)
                return
            }
        }
    }
}



