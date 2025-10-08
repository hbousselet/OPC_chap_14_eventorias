//
//  Event.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 23/09/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Event: Codable {
    let identifier: String?
    let address: GeoPoint?
    let date: Date
    let description: String
    let name: String
    let image: String?
    let user: String?
}

extension Event {
    static func fetchEvents() async throws -> [Event] {
        do {
            let db = Firestore.firestore()
            var events: [Event] = []
            let eventsFetched = try await db.collection("Event").getDocuments()
            for event in eventsFetched.documents {
                let ev = try event.data(as: Event.self)
                events.append(ev)
            }
            return events
            
        } catch {
            print("Error getting documents: \(error)")
            throw error
        }
    }
    
    static func createEvent(event: Event) async throws {
//        do {
//            let db = Firestore.firestore()
//            try await db.collection("Event").addDocument(data: <#T##[String : Any]#>)
//        } catch {
//            print("Error adding document: \(error)")
//            throw error
//        }
    }
    
    func convert() -> EventModel {
        EventModel(from: self)
    }
}

extension Event {
    public init(from eventModel: EventModel) {
        self.init(identifier: nil,
                  address: GeoPoint(latitude: eventModel.address.latitude, longitude: eventModel.address.longitude),
                  date: eventModel.date,
                  description: eventModel.description,
                  name: eventModel.name,
                  image: "",
                  user: eventModel.profil?.name) // ça ne va pas
    }
}
