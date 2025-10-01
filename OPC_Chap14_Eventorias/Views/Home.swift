//
//  Home.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct Home: View {
    @Environment(AuthFirebase.self) private var firebase
    @SceneStorage("selectedTab") private var selectedTabIndex = 0

    @State private var eventViewModel: EventsViewModel = EventsViewModel(event: [])
    var onLogout: () -> Void = { }

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Events", systemImage: "1.circle", value: 0) {
                EventsList()
                    .environment(eventViewModel)
            }
            Tab("Profile", systemImage: "2.circle", value: 1) {
                Profile()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
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
