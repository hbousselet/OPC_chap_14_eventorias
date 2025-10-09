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
    @State private var userViewModel: UserViewModel = UserViewModel()
    
    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Events", systemImage: "1.circle", value: 0) {
                NavigationStack {
                    EventsList()
                        .environment(eventViewModel)
                }
            }
            Tab("Profile", systemImage: "2.circle", value: 1) {
                NavigationStack {
                    Profile(viewModel: userViewModel)
                        .environment(eventViewModel)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .navigationBarBackButtonHidden(true)
        .task {
            await eventViewModel.fetchEvents()
            await userViewModel.fetchUser()
        }
    }
}
