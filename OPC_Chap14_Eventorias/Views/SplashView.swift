//
//  SplashView.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct SplashView: View {
    @State var presentLoginView: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack {
                    Image("logo_eventorias")
                        .resizable()
                        .frame(width: 64, height: 67)
                    Image("title_eventorias")
                        .resizable()
                        .frame(width: 242, height: 21)
                        .padding(.top, 32)
                    Button {
                        presentLoginView.toggle()
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
            .navigationDestination(isPresented: $presentLoginView) {
                LoginView()
            }
        }
    }
}

#Preview {
    SplashView()
}
