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

@Observable @MainActor class EventsViewModel {
    private(set) var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    var alertIsPresented: Bool = false
    var alert: EventsAlert? = Optional.none
    var sorting: EventsSorting = .none
    
    let imageLoader = ImageLoader.shared
    
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
        await withTaskGroup() { taskGroup in
            let firestoreEvents = await Event.fetchEvents()
            let convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in convertedEvents.enumerated() {
                await MainActor.run { self.events.append(convertedEvents[index]) }
                
                taskGroup.addTask {
                    do {
                        try await self.imageLoader.downloadImageWithPath(from: event.image, with: event.name.removeSpacesAndLowercase())
                        await MainActor.run { self.events[index].canFetchEventImage = true }
                    } catch {
                        await MainActor.run {
                            self.alertIsPresented = true
                            self.alert = error as? EventsAlert
                        }
                    }
                }
                
                taskGroup.addTask {
                    do {
                        let user = try await User.fetchUser(event.user)
                        try await self.imageLoader.downloadImageWithUrl(from: user.icon, with: user.email)
                        await MainActor.run { self.events[index].profil = user }
                    } catch {
                        await MainActor.run {
                            self.alertIsPresented = true
                            self.alert = error as? EventsAlert
                        }
                    }
                }
                
            }
        }

    }
    
    func getImage(name: String) -> UIImage {
        print("get image for : \(name)")
        if let cachedImage = ImageLoader.shared.getImage(forKey: name) {
            print("could get the image")
            return cachedImage
        }
        print("not able to get the image")
        return UIImage(named: "placeholder-rectangle")!
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

enum EventsAlert: Error {
    case notAbleToFetchEvents(error: Error)
    case notAbleToDownloadImage(error: Error)
    case notAbleToFetchUser(error: Error)
    case userDoesNotExist
    case notAbleToLoadUserImage(error: Error)
    case none
    
    var errorDescription: String? {
        switch self {
        case .none:
            return "No error"
        case .notAbleToFetchEvents(error: let error):
            return "Not able to fetch events : \(error.localizedDescription)"
        case .notAbleToDownloadImage(error: let error):
            return "Not able to download image : \(error.localizedDescription)"
        case .notAbleToFetchUser(error: let error):
            return "Not able to fetch user : \(error.localizedDescription)"
        case .notAbleToLoadUserImage(error: let error):
            return "Not able to load user's image : \(error.localizedDescription)"
        case .userDoesNotExist:
            return "User does not exist"
        }
    }
}

enum EventsSorting {
    case none, dateAscending, dateDescending
}
