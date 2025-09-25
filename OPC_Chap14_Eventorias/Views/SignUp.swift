//
//  SignUp.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 25/09/2025.
//

import SwiftUI

struct SignUp: View {
    @State var viewModel: AuthtenticationViewModel = AuthtenticationViewModel()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray.ignoresSafeArea(.all)
            VStack {
                CustomPrompt(title: "Name",
                             promptValue: $viewModel.name)
                CustomPrompt(title: "Email",
                             promptValue: $viewModel.email)
                CustomPassword(title: "Password",
                               addForgotPasswordIndication: true,
                               promptValue: $viewModel.password)
                Button {
                    Task {
                        await viewModel.signUp()
                    }
                } label: {
                    HStack(alignment: .center) {
                        Text("Sign up")
                            .foregroundStyle(.white)
                    }
                    .frame(width: 242, height: 52)
                    .padding(.horizontal)
                    .background(.red)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text("Sign up")
                    .foregroundStyle(.white)
            }
        }
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            Home()
        }
    }
}

#Preview {
    SignUp()
}
