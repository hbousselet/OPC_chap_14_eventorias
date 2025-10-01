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
    let name: String
    let description: String
    let date: Date
    let user: String? // afin de choper la photoURL
    let address: Address?
    let image: URL?
    var profil: User?
    
    init(id: UUID, name: String, description: String, date: Date, user: String?, address: Address?, image: URL?, profil: User? = nil) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.user = user
        self.address = address
        self.image = image
        self.profil = profil
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
                  name: event.name,
                  description: event.description,
                  date: event.date,
                  user: event.user,
                  address: Address(latitude: event.address?.latitude ?? EventModel.defaultLat,
                                   longitude: event.address?.longitude ?? EventModel.defaultLong),
                  image: URL(string: event.image ?? "")
                    )
    }
}
