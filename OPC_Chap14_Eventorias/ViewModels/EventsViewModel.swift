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

@Observable class EventsViewModel {
    var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    
    init(event: [EventModel]) {
        self.events = events
    }
    
    func fetchEvents() async {
        do {
            let firestoreEvents = try await Event.fetchEvents()
            let convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in convertedEvents.enumerated() {
                guard let userid = event.user else { continue }
                let user = try await User.fetchUser(userid)
                convertedEvents[index].profil = user
            }
            events = convertedEvents
        } catch {
            print("error : \(error)")
        }
    }
    
    
}
    
