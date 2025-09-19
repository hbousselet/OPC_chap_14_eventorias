//
//  EventsViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth

@Observable class EventsViewModel {
    var events: [EventModel] = []
    var search: String = ""
    
    init() {
        events = buildFakeEventModel()
    }
    
    func fetchEvents() async {
        // call firestore
    }
    
    private func buildFakeEventModel() -> [EventModel] {
        [
            EventModel(id: 0, title: "Festival", description: "BALBAKASKJNJHDCBJJHDCB CD", date: Date.now, user: Auth.auth().currentUser, address: Address(street: "130 rue de Bourgogne", city: "Paris", postalCode: "75007"), image: URL(string: "https://picsum.photos/id/237/200/300?grayscale")),
            EventModel(id: 1, title: "Cinema", description: "BALBAKASKJNJHDCBJJHDCB CD", date: Date.now, user: Auth.auth().currentUser, address: Address(street: "130 rue de Bourgogne", city: "Paris", postalCode: "75007"), image: URL(string: "https://picsum.photos/id/238/200/300?grayscale")),
            EventModel(id: 2, title: "Football", description: "BALBAKASKJNJHDCBJJHDCB CD", date: Date.now, user: Auth.auth().currentUser, address: Address(street: "130 rue de Bourgogne", city: "Paris", postalCode: "75007"), image: URL(string: "https://picsum.photos/id/27/200/300?grayscale")),
            EventModel(id: 3, title: "Musee", description: "BALBAKASKJNJHDCBJJHDCB CD", date: Date.now, user: Auth.auth().currentUser, address: Address(street: "130 rue de Bourgogne", city: "Paris", postalCode: "75007"), image: URL(string: "https://picsum.photos/id/2/200/300?grayscale")),
            EventModel(id: 4, title: "Voyage", description: "BALBAKASKJNJHDCBJJHDCB CD", date: Date.now, user: Auth.auth().currentUser, address: Address(street: "130 rue de Bourgogne", city: "Paris", postalCode: "75007"), image: URL(string: "https://picsum.photos/id/28/200/300?grayscale"))
        ]
    }
    
}
