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
    
    func convert() -> EventModel {
        EventModel(from: self)
    }
}
