//
//  EventsViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

@MainActor
protocol EventsProtocol {
    func fetchEvents() async
    func fetchEvent(with documentId: String) async
    func sortingHit()
}

@Observable class EventsViewModel: EventsProtocol {
    private(set) var events: [EventModel] = []
    var search: String = ""
    var sorting: EventsSorting = .none
    var documentId: String?
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts? = Optional.none
    
    let eventFirestore: FirestoreProtocol
    let userFirestore: FirestoreProtocol
    let storage: StorageProtocol


        
    var filteredEvents: [EventModel] {
        if search.isEmpty {
            return events.sortedByDate(by: sorting)
        } else {
            return events.filter( { $0.type.rawValue.lowercased().contains(search.lowercased()) })
                .sortedByDate(by: sorting)
        }
    }
    
    init(event: [EventModel],
         eventFirestore: FirestoreProtocol = FirestoreService(collection: "Event"),
         userFirestore: FirestoreProtocol = FirestoreService(collection: "User"),
         storage: StorageProtocol = StorageService()) {
        self.eventFirestore = eventFirestore
        self.userFirestore = userFirestore
        self.storage = storage
        self.events = events
    }
        
    func fetchEvents() async {
        do {
                let firestoreEvents = try await Event.fetchEvents(firestoreService: eventFirestore)
                let convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
                
            for (index, event) in convertedEvents.enumerated() {
                let user = try await UserFirestore.fetchUser(event.user, firestoreService: userFirestore)
                let imageUrl = try await retrieveImageUrl(of: event.image)
                events.append(event)
                events[index].profil = user
                events[index].imageUrl = imageUrl
            }
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts
        }
    }
    
    private func retrieveImageUrl(of path: String) async throws -> URL? {
        storage.child("images/\(path).jpg")
        do {
            return try await storage.downloadURL()
        } catch {
            throw EventoriasAlerts.imageUrlNotFound
        }
    }
    
    func fetchEvent(with documentId: String) async {
        do {
            let firestoreEvent = try await Event.fetchEvent(with: documentId, firestoreService: eventFirestore)
            var convertedEvent: EventModel = firestoreEvent.convert()
            let user = try await UserFirestore.fetchUser(convertedEvent.user, firestoreService: userFirestore)
            let imageUrl = try await retrieveImageUrl(of: convertedEvent.image)
            convertedEvent.profil = user
            convertedEvent.imageUrl = imageUrl
            events.append(convertedEvent)

        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts
        }
    }
    
    func sortingHit() {
        switch sorting {
        case .none:
            sorting = .dateDescending
        case .dateDescending:
            sorting = .dateAscending
        case .dateAscending:
            sorting = .none
        }
    }
}

enum EventsSorting {
    case none, dateAscending, dateDescending
}
