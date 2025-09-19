//
//  EventModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import FirebaseAuth

struct EventModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let date: Date
    let user: User? // afin de choper la photoURL
    let address: Address
    let image: URL?
}

struct Address: Codable {
    let street: String
    let city: String
    let postalCode: String
}
