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
                Color.systemBackground.edgesIgnoringSafeArea(.all)
                VStack {
                    CustoTextfield(title: "Email",
                                   introduction: "marie-george_buffet412@gmail.com",
                                   keyboardType: .default,
                                   promptValue: $viewModel.email,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top)
                    CustoTextfieldPassword(title: "Password",
                                   introduction: "",
                                   keyboardType: .default,
                                   promptValue: $viewModel.password,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, 15)
                    HStack(alignment: .center) {
                        Button {
                            Task {
                                await viewModel.signIn()
                                if viewModel.isAuthenticated {
                                    firebase.isAuthenticated = true
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Sign in")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(width: 100, height: 52)
                        .padding(.horizontal)
                        .background(.red)
                        Button {
                            presentSignUp = true
                        } label: {
                            Text("Sign up")
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .frame(width: 100, height: 52)
                        .padding(.horizontal)
                        .background(.red)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                }
            }
            .alert(isPresented: $viewModel.alertIsPresented) {
                Alert(title: Text("Important message"), message: Text(viewModel.alert?.errorDescription ?? "An error occurred"), dismissButton: .default(Text("Got it!")))
            }
            .navigationTitle("Sign in")
            .navigationDestination(isPresented: $presentSignUp) {
                SignUp()
            }
        }
    }
}
