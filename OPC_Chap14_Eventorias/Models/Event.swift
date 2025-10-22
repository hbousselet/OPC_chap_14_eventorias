//
//  Event.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 23/09/2025.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Event: Codable, IdentifiableByString {
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
    static func fetchEvents(firestoreService: any DBAccessProtocol) async throws -> [Event] {
        do {
            let events: [Event] = try await firestoreService.multipleFetch()
            return events
        } catch {
            throw EventoriasAlerts.failedMultiFetch
        }
    }
    
    static func fetchEvent(with documentId: String,
                           firestoreService: any DBAccessProtocol) async throws -> Event {
        do {
            let event: Event = try await firestoreService.uniqueFetch(id: documentId)
            return event
        } catch {
            throw EventoriasAlerts.failedFetch
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

