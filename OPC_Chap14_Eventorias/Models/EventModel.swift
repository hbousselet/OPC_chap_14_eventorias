//
//  EventModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class EventModel: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let date: Date
    let userUrl: URL? // afin de choper la photoURL
    let address: Address?
    let image: URL?
    
    init(id: UUID, title: String, description: String, date: Date, userUrl: URL?, address: Address?, image: URL?) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.userUrl = userUrl
        self.address = address
        self.image = image
    }
    
    static let defaultLat: Double = 48.856019
    static let defaultLong: Double = 2.310863
    
}

public struct Address: Codable {
    let latitude: Double
    let longitude: Double
}


extension EventModel {
    convenience init(from event: Event) {
        self.init(id: UUID(),
                  title: event.title,
                  description: event.description,
                  date: event.date,
                  userUrl: URL(string: event.userURL ?? ""),
                  address: Address(latitude: event.address?.latitude ?? EventModel.defaultLat,
                                   longitude: event.address?.longitude ?? EventModel.defaultLong),
                  image: URL(string: event.imageURL ?? ""))
    }
}
