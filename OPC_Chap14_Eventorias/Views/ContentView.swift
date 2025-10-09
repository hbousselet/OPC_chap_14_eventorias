//
//  ContentView.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 25/09/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State var navPath = NavigationPath()
    @State private var firebaseAuth: AuthFirebase = AuthFirebase()
    
    var body: some View {
        if firebaseAuth.isAuthenticated {
            Home()
                .environment(firebaseAuth)
        } else {
            SplashView()
        }
    }
}

#Preview {
    ContentView()
}
