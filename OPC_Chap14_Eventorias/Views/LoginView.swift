//
//  LoginView.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: SignInViewModel
    
    init() {
        self.viewModel = SignInViewModel()
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.gray.ignoresSafeArea(.all)
            VStack {
                CustomPrompt(title: "Email",
                             promptValue: $viewModel.email)
                CustomPassword(title: "Password",
                               addForgotPasswordIndication: true,
                               promptValue: $viewModel.password)
                Button {
                    Task {
                        await viewModel.signIn()
                    }
                } label: {
                    HStack(alignment: .center) {
                        Text("Sign in")
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
                Text("Login")
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    LoginView()
}
