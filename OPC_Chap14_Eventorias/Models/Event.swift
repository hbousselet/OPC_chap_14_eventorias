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
    let type: EventType
}

extension Event {
    static func fetchEvents() async throws -> [Event] {
        let db = Firestore.firestore()
        do {
            var events: [Event] = []
            let eventsFetched = try await db.collection("Event").getDocuments()
            for event in eventsFetched.documents {
                let convertedEvent = try event.data(as: Event.self)
                events.append(convertedEvent)
            }
            return events
            
        } catch {
            throw EventoriasAlerts.notAbleToFetchEvents(error: error)
        }
    }
    
    static func fetchEvent(with documentId: String) async throws -> Event {
        let db = Firestore.firestore()
        let docRef = db.collection("Event").document(documentId)
        
        do {
            let event = try await docRef.getDocument(as: Event.self)
            return event
        } catch {
            throw EventoriasAlerts.notAbleToFetchEvents(error: error)
        }
    }
    
    func convert() -> EventModel {
        EventModel(from: self)
    }
}

enum EventType: String, Codable, Hashable, Identifiable, CaseIterable {
    var id: Self { self }
    case restaurant
    case bar
    case museum
    case club
    case festival
    case sport
    case other
    case conference
    case art
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let type = try? container.decode(String.self)
        switch type {
        case "restaurant": self = .restaurant
        case "bar": self = .bar
        case "museum": self = .museum
        case "club": self = .club
        case "festival": self = .festival
        case "sport": self = .sport
        case "other": self = .other
        case "conference": self = .conference
        case "art": self = .art
        default:
            self = .other
        }
    }
}

