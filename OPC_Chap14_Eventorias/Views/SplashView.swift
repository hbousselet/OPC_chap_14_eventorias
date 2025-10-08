//
//  SplashView.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI
import FirebaseAuth

struct SplashView: View {
    @State var presentSignInView: Bool = false
    @State private var firebaseAuth: AuthFirebase = AuthFirebase()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.customGray.edgesIgnoringSafeArea(.all)
            VStack {
                Image("logo_eventorias")
                    .resizable()
                    .frame(width: 64, height: 67)
                Image("title_eventorias")
                    .resizable()
                    .frame(width: 242, height: 21)
                    .padding(.top, 32)
                Button {
                    presentSignInView.toggle()
                } label: {
                    HStack(alignment: .center) {
                        Image("vector")
                        Text("Sign in with email")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 242, height: 52)
                    .padding(.horizontal)
                    .background(.red)
                }
                .padding(.top, 64)
            }
            .padding(.top, 70)
        }
        .fullScreenCover(isPresented: $presentSignInView) {
            SignIn()
                .environment(firebaseAuth)
        }
        .navigationDestination(isPresented: $firebaseAuth.isAuthenticated ) {
            Home()
                .environment(firebaseAuth)
        }
        .onAppear {
            print("Hello firebase : \(firebaseAuth.isAuthenticated)")
        }
    }
}
