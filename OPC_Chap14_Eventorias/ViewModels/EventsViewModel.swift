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
    
    init() {
    }
    
    func fetchEvents() async {
        do {
            let firestoreEvents = try await Event.fetchEvents()
            events = firestoreEvents.compactMap { $0.convert() }
            print("eventviewmodel= \(events)")
        } catch {
            print("error : \(error)")
        }
        
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            signOut = true
        } catch {
            print("Error at signout: \(error)")
        }
    }
    
}
    
