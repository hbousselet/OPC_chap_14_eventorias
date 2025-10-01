//
//  SignIn.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct SignIn: View {
    @State var viewModel: AuthtenticationViewModel = AuthtenticationViewModel()
    @State var presentSignUp: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(AuthFirebase.self) private var firebase
    
    
    var body: some View {
        NavigationStack {
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
                            if viewModel.isAuthenticated {
                                firebase.isAuthenticated = true
                                dismiss()
                            }
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
                    Button {
                        presentSignUp = true
                    } label: {
                        Text("Sign up")
                            .frame(width: 242, height: 52)
                            .padding(.horizontal)
                            .background(.red)
                    }
                    .frame(width: 242, height: 52)
                    .padding(.horizontal)
                    .background(.red)
                }
            }
            .navigationDestination(isPresented: $presentSignUp) {
                SignUp()
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
//#Preview {
//    SignIn()
//}
