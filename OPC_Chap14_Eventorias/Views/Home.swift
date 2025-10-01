//
//  Home.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct Home: View {
    @Environment(AuthFirebase.self) private var firebase
    @State private var search: String = ""
    @State private var eventViewModel: EventsViewModel = EventsViewModel(event: [])
    var onLogout: () -> Void = { }

    var body: some View {
        TabView {
            Tab("Events", systemImage: "4.circle", role: .search) {
                EventsList()
                    .environment(eventViewModel)
            }
            Tab("Profile", systemImage: "2.circle") {
                Profile()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .searchable(text: $search)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    firebase.logout()
                    onLogout()
                } label: {
                    Label("LogOut", systemImage: "rectangle.portrait.and.arrow.right")
                }
                .foregroundStyle(.white)
            }
        }
    }
}
