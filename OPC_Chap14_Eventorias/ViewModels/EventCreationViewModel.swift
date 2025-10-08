//
//  EventCreationViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 08/10/2025.
//

import Foundation
import MapKit

@Observable class EventCreationViewModel {
    var title: String = ""
    var description: String = ""
    var date: String = ""
    var time: String = ""
    var address: String = ""
    var addressEnteredRequested: MKMapItem?
    
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
}



