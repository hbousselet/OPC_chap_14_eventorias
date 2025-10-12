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
    var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    
    let imageLoader = ImageLoader.shared
    
    init(event: [EventModel]) {
        self.events = events
    }
    
    func fetchEvents() async {
        do {
            let firestoreEvents = try await Event.fetchEvents()
            var convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in convertedEvents.enumerated() {
                await imageLoader.downloadImageInStorage(from: event.image, with: event.name.removeSpacesAndLowercase())
                guard let userid = event.user else { continue }
                let user = try await User.fetchUser(userid)
                convertedEvents[index].profil = user
                await imageLoader.downloadImage(from: user.icon, with: user.email)
                //events ajouté à chaque fois qu'un est fetch
                events.append(convertedEvents[index])
            }
            // events ajoutés à la fin
//            events = convertedEvents
        } catch {
            print("error : \(error)")
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
