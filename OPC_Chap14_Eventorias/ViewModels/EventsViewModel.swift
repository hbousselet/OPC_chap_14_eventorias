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

@Observable class EventsViewModel {
    private(set) var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    var alertIsPresented: Bool = false
    var alert: EventsAlert? = Optional.none
    
    let imageLoader = ImageLoader.shared
    
    var searchEvents: [EventModel] {
        if search.isEmpty {
            return events
        } else {
            return events.filter { $0.type.rawValue.lowercased().contains(search.lowercased()) }
        }
    }
    
    init(event: [EventModel]) {
        self.events = events
    }
    
    func fetchEvents() async {
        do {
            let firestoreEvents = try await Event.fetchEvents()
            var convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in convertedEvents.enumerated() {
                try await imageLoader.downloadImageInStorage(from: event.image, with: event.name.removeSpacesAndLowercase())
                guard let userid = event.user else { continue }
                let user = try await User.fetchUser(userid)
                convertedEvents[index].profil = user
                try await imageLoader.downloadImage(from: user.icon, with: user.email)
                //events ajouté à chaque fois qu'un est fetch
                events.append(convertedEvents[index])
            }
            // events ajoutés à la fin
//            events = convertedEvents
        } catch {
            print("error : \(error)")
            alertIsPresented = true
            alert = error as? EventsAlert
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
