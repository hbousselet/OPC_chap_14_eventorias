//
//  Profile.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct Profile: View {
    @State private var viewModel: UserViewModel
    @Environment(EventsViewModel.self) private var eventViewModel: EventsViewModel
    
    init(viewModel: UserViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.customGray.ignoresSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading) {
                    CustoTextfield(title: "Name",
                                   introduction: "",
                                   keyboardType: .default,
                                   promptValue: $viewModel.user.name,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, 36)
                    CustoTextfield(title: "E-mail",
                                   introduction: "",
                                   keyboardType: .emailAddress,
                                   promptValue: $viewModel.user.email,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, 24)
                    Toggle("Notifications", isOn: $viewModel.user.notification)
                        .toggleStyle(.switch)
                        .tint(.red)
                        .padding(.top, 32)
                        .disabled(true)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .padding(.top, 66)
            .ignoresSafeArea(edges: .top)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(uiImage: eventViewModel.getImage(name: viewModel.user.email))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
            }
            ToolbarItem(placement: .title) {
                Text("User profile")
                    .foregroundStyle(.black)
            }
        }
    }
}
