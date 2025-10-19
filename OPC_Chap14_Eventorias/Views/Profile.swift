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
            Color.systemBackground.ignoresSafeArea(.all)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 24) {
                        CustoTextfield(title: "Name",
                                       introduction: "",
                                       keyboardType: .default,
                                       promptValue: $viewModel.user.name,
                                       size: CGSize(width: 358, height: 56))
                        CustoTextfield(title: "E-mail",
                                       introduction: "",
                                       keyboardType: .emailAddress,
                                       promptValue: $viewModel.user.email,
                                       size: CGSize(width: 358, height: 56))
                    }
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Toggle("", isOn: $viewModel.user.notification)
                            .toggleStyle(.switch)
                            .tint(.red)
                        Text("Notifications")
                            .font(.custom("Inter_18pt-Regular", size: 16))
                            .padding(.leading, 12)
                        Spacer()
                    }
//                    .offset(x: -300)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 36)
            }
            .padding(.top, 66)
            .ignoresSafeArea(edges: .top)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Image(uiImage: eventViewModel.getImage(name: viewModel.user.email, isPortrait: true))
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
            ToolbarItem(placement: .topBarLeading) {
                Text("User profile")
                    .font(.custom("Inter_18pt-Medium", size: 20))
                    .fixedSize()
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }
}
