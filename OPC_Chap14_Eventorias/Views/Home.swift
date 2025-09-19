//
//  Home.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct Home: View {
    @State private var search: String = ""
    @State private var eventViewModel: EventsViewModel = EventsViewModel()
    var body: some View {
        TabView {
            Tab("Events", systemImage: "4.circle", role: .search) {
                NavigationStack {
                    EventsList()
                        .environment(eventViewModel)
                }
            }
            Tab("Profile", systemImage: "2.circle") {
                Profile()
            }
        }
        .searchable(text: $search)
    }
}

#Preview {
    Home()
}
