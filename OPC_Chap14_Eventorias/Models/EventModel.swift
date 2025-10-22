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


struct EventModel: Identifiable, Equatable, Hashable {
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
    
    let id: UUID
    let name: String
    let description: String
    let date: Date
    let user: String
    let address: Address
    let image: String
    var imageUrl: URL?
    var profil: UserFirestore?
    let type: EventType
    var canFetchEventImage: Bool = false
    

    init(id: UUID, name: String, description: String, date: Date, user: String, address: Address, image: String, imageUrl: URL? = nil, profil: UserFirestore? = nil, type: EventType) {
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.user = user
        self.address = address
        self.image = image
        self.imageUrl = imageUrl
        self.profil = profil
        self.type = type
    }
    
    static let defaultLat: Double = 48.856019
    static let defaultLong: Double = 2.310863
    
}

public struct Address: Codable, Hashable, Equatable {
    let latitude: Double
    let longitude: Double
}


extension EventModel {
    init(from event: Event) {
        self.init(id: UUID(),
                  name: event.name,
                  description: event.description,
                  date: event.date,
                  user: event.user ?? "",
                  address: Address(latitude: event.address?.latitude ?? EventModel.defaultLat,
                                   longitude: event.address?.longitude ?? EventModel.defaultLong),
                  image: event.image ?? "",
                  type: event.type
                    )
    }
}

extension [EventModel] {
    func sortedByDate(by sorting: EventsSorting) -> [EventModel] {
        self.sorted { before, after in
            switch sorting {
            case .none:
                return false
            case .dateAscending:
                return before.date < after.date
            case .dateDescending:
                return before.date > after.date
            }
        }
    }
}
