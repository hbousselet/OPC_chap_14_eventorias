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
        
    var filteredEvents: [EventModel] {
        if search.isEmpty {
            return events.sortedByDate(by: sorting)
        } else {
            return events.filter( { $0.type.rawValue.lowercased().contains(search.lowercased()) })
                .sortedByDate(by: sorting)
        }
    }
    
    init(event: [EventModel]) {
        self.events = events
    }
        
    func fetchEvents() async {
        do {
                let firestoreEvents = try await Event.fetchEvents()
                let convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
                
            for (index, event) in convertedEvents.enumerated() {
                let user = try await User.fetchUser(event.user)
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
        let imageRef = Storage.storage().reference().child("images/\(path).jpg")
        do {
            return try await imageRef.downloadURL()
        } catch {
            throw EventoriasAlerts.imageUrlNotFound
        }
    }
    
    func fetchEvent(with documentId: String) async {
        do {
            let firestoreEvent = try await Event.fetchEvent(with: documentId)
            var convertedEvent: EventModel = firestoreEvent.convert()
            let user = try await User.fetchUser(convertedEvent.user)
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
