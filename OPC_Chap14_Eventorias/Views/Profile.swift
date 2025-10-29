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
                    
                    HStack {
                        Text("Notifications")
                            .font(.custom("Inter_18pt-Regular", size: 16))
                            .padding(.leading, 12)
                        Toggle("", isOn: $viewModel.user.notification)
                            .toggleStyle(.switch)
                            .tint(.red)
                        Spacer()
                    }
                    
                    .accessibilityElement(children: .combine)
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 36)
            }
            .padding(.top, 80)
            .ignoresSafeArea(edges: .top)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                UserImage(url: viewModel.user.icon, size: CGSize(width: 32, height: 32))
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

struct UserImage: View {
    let url: URL?
    let size: CGSize
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size.width, height: size.height)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
            case .failure:
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: size.width, height: size.height)
            @unknown default:
                EmptyView()
            }
        }
    }
}
