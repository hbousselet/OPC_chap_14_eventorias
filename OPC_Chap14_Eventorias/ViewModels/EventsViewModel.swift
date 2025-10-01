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
            events = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in events.enumerated() {
                guard let userid = event.user else { continue }
                let user = try await User.fetchUser(userid)
                events[index].profil = user
            }
        } catch {
            print("error : \(error)")
        }
    }
    
    
}
    
