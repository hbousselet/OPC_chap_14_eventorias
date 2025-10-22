//
//  SignIn.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct SignIn: View {
    @State var viewModel: AuthenticationViewModel = AuthenticationViewModel()
    @State var presentSignUp: Bool = false
    @Environment(\.dismiss) var dismiss
    @Environment(FirebaseService.self) private var firebase
    
    
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
                                if firebase.isAuthenticated {
                                    dismiss()
                                }
                            }
                        } label: {
                            Text("Sign in")
                                .foregroundStyle(.white)
                                .font(.custom("Inter_18pt-SemiBold", size: 16))
                        }
                        .frame(width: 100, height: 52)
                        .padding(.horizontal)
                        .background(.red)
                        Button {
                            presentSignUp = true
                        } label: {
                            Text("Sign up")
                                .foregroundStyle(.white)
                                .font(.custom("Inter_18pt-SemiBold", size: 16))
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
