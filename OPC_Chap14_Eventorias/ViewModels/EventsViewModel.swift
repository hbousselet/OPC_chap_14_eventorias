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
    func getImage(name: String, isPortrait: Bool) -> UIImage
    func sortingHit()
}

@Observable class EventsViewModel: EventsProtocol {
    private(set) var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    var alertIsPresented: Bool = false
    var alert: EventoriasAlerts? = Optional.none
    var sorting: EventsSorting = .none
    var documentId: String?
    
    let imageLoader: LoaderProtocol
    
    var filteredEvents: [EventModel] {
        if search.isEmpty {
            return events.sortedByDate(by: sorting)
        } else {
            return events.filter( { $0.type.rawValue.lowercased().contains(search.lowercased()) })
                .sortedByDate(by: sorting)
        }
    }
    
    init(event: [EventModel], imageLoader: LoaderProtocol = ImageLoader.shared) {
        self.imageLoader = imageLoader
        self.events = events
    }
    
    func fetchEvents() async {
        do {
            try await withThrowingTaskGroup(of: Void.self) { [weak self] taskGroup in
                let firestoreEvents = try await Event.fetchEvents()
                let convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
                
                for (index, event) in convertedEvents.enumerated() {
                    await MainActor.run { self?.events.append(convertedEvents[index]) }
                    
                    taskGroup.addTask {
                        try await self?.imageLoader.downloadImageWithPath(from: event.image, with: event.name.removeSpacesAndLowercase())
                        await MainActor.run { self?.events[index].canFetchEventImage = true }
                    }
                    
                    taskGroup.addTask {
                        let user = try await User.fetchUser(event.user)
                        try await self?.imageLoader.downloadImageWithUrl(from: user.icon, with: user.email)
                        await MainActor.run { self?.events[index].profil = user }
                    }
                    
                }
            }
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts
        }
    }
    
    func fetchEvent(with documentId: String) async {
        do {
            try await withThrowingTaskGroup(of: Void.self) { [weak self] taskGroup in
                let firestoreEvent = try await Event.fetchEvent(with: documentId)
                var convertedEvent: EventModel = firestoreEvent.convert()
                                
                taskGroup.addTask {
                    try await self?.imageLoader.downloadImageWithPath(from: convertedEvent.image, with: convertedEvent.name.removeSpacesAndLowercase())
                    await MainActor.run { self?.events[(self?.events.count ?? 1) - 1].canFetchEventImage = true }
                }
                
                taskGroup.addTask {
                    let user = try await User.fetchUser(convertedEvent.user)
                    try await self?.imageLoader.downloadImageWithUrl(from: user.icon, with: user.email)
                    convertedEvent.profil = user
                    await MainActor.run { self?.events.append(convertedEvent) }
                }
            }
        } catch {
            alertIsPresented = true
            alert = error as? EventoriasAlerts
        }
    }
    
    func getImage(name: String, isPortrait: Bool = false) -> UIImage {
        if let cachedImage = ImageLoader.shared.getImage(forKey: name) {
            return cachedImage
        }
        if isPortrait {
            return UIImage(named: "portrait-placeholder")!
        } else {
            return UIImage(named: "image-placeholder")!
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
