//
//  SignUp.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 25/09/2025.
//

import SwiftUI

struct SignUp: View {
    @State var viewModel: AuthtenticationViewModel = AuthtenticationViewModel()
    @Environment(\.dismiss) var dismiss
    @Environment(AuthFirebase.self) private var firebase

    var body: some View {
        ZStack(alignment: .top) {
            Color.systemBackground.edgesIgnoringSafeArea(.all)
            VStack {
                CustoTextfield(title: "Name",
                               introduction: "Marie George Aimée Buffet",
                               keyboardType: .default,
                               promptValue: $viewModel.name,
                               size: CGSize(width: 358, height: 56))
                .padding(.top)
                CustoTextfield(title: "Email",
                               introduction: "marie-george_buffet412@gmail.com",
                               keyboardType: .default,
                               promptValue: $viewModel.email,
                               size: CGSize(width: 358, height: 56))
                .padding(.top, 15)
                CustoTextfieldPassword(title: "Password",
                               introduction: "",
                               keyboardType: .default,
                               promptValue: $viewModel.password,
                               size: CGSize(width: 358, height: 56))
                .padding(.top, 15)
                Button {
                    Task {
                        await viewModel.signUp()
                        if firebase.isAuthenticated {
                            dismiss()
                        }
                    }
                } label: {
                        Text("Sign up")
                            .foregroundStyle(.white)
                            .font(.custom("Inter_18pt-SemiBold", size: 16))
                            .padding(.horizontal)
                            .padding(.top)
                    }
                .frame(width: 168, height: 52)
                .padding(.horizontal)
                .padding(.top, 15)
                .background(.red)
                }
            }
        .alert(isPresented: $viewModel.alertIsPresented) {
            Alert(title: Text("Important message"), message: Text(viewModel.alert?.errorDescription ?? "An error occurred"), dismissButton: .default(Text("Got it!")))
        }
        .navigationTitle("Sign up")
//        .toolbar {
//            ToolbarItem(placement: .title) {
//                Text("Sign up")
//                    .foregroundStyle(.white)
//            }
//        }
    }
}
