//
//  EventsList.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct EventsList: View {
    @Environment(EventsViewModel.self) private var viewModel
    @Environment(AuthFirebase.self) private var firebase

    @State var isNavigating: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                ZStack(alignment: .bottomTrailing) {
                    addEventButton()
                        .zIndex(2)
                    Color.customGray.ignoresSafeArea(.all)
                    ScrollView {
                        VStack(alignment: .leading) {
                            CustomTextField(viewModel: viewModel)
                            sortingCapsule()
                            if viewModel.events.isEmpty {
                                loadingView(width: geometry.size.width * 0.9, height: 80)
                            } else { ForEach(viewModel.events, id: \.id) { event in
                                NavigationLink(destination: {
                                    EventDetails(event: event)
                                        .environment(viewModel)
                                }, label: {
                                    eventElement(event, with: geometry.size)
                                        .frame(width: geometry.size.width * 0.9, height: 80)
                                })
                            }
                            .padding(.top, 4)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .zIndex(1)
                }
            }
        }
        .navigationDestination(isPresented: $isNavigating) {
            EventCreation(isPresented: $isNavigating)
                .environment(viewModel)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    firebase.logout()
                } label: {
                    Text("Deconexion")
                }
            }
        }
    }
    
    private func loadingView(width: CGFloat, height: CGFloat) -> some View {
        ZStack(alignment: .center) {
            ProgressView()
                .tint(.red)
                .scaleEffect(4.0)
                .offset(y: -60)
                .zIndex(2)
            VStack {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.gray)
                        .background(.gray, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.top, 4)
                        .frame(width: width,height: height)
                }
            }
            .zIndex(1)
        }
    }

    
    private func addEventButton() -> some View {
        Button {
            isNavigating.toggle()
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .frame(width: 56, height: 56)
                .foregroundStyle(.clear)
                .overlay {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .background(.clear)
                }
        }
        .glassEffect(.clear)
    }
    
    private func eventElement(_ event: EventModel, with size: CGSize) -> some View {
        HStack {
//            image(with: event.profil?.icon, size: CGSize(width: 40.0, height: 40.0))
            imageInCached(name: event.profil?.email ?? "",
                          size: CGSize(width: 40.0, height: 40.0))
                .clipShape(.circle)
                .padding(.leading, 16)
                .padding(.vertical, 20)
            VStack {
                Text(event.name)
                    .lineLimit(1)
                    .font(.system(size: 16, weight: .medium))
                Text(event.date, format: .dateTime.month(.abbreviated).year().day())
                    .lineLimit(1)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.vertical, 16)
            .padding(.horizontal)
            Spacer()
//            image(with: event.image, size: CGSize(width: 136.0, height: 80.0))
            imageInCached(name: event.image,
                          size: CGSize(width: 136.0, height: 80.0))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(width: size.width * 0.9, height: 80)
        .background(.gray, in: RoundedRectangle(cornerRadius: 12))
        .foregroundStyle(.white)
    }
    
    private func sortingCapsule() -> some View {
        Button {
            // to do
        } label: {
            HStack {
                Image(systemName: "heart")
                Text("Sorting")
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .foregroundStyle(.white)
        }
        .background(.gray, in: .capsule)
    }
    
    @ViewBuilder
    private func image(with url: URL?, size: CGSize) -> some View {
        AsyncImage(url: url,
                   transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .success(let image):
                image.resizable()
                    .scaledToFill()
                    .frame(width: size.width, height: size.height)
                    .clipped()
            default:
                ZStack(alignment: .center) {
                    Image("placeholder-rectangle")
                        .frame(width: size.width, height: size.height)
                        .zIndex(1)
                        .clipped()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .zIndex(2)
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private func imageInCached(name: String, size: CGSize) -> some View {
        Image(uiImage: viewModel.getImage(name: name))
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
    }
}

struct CustomTextField: View {
    @State var viewModel: EventsViewModel
    
    var body: some View {
        TextField("Search", text: $viewModel.search)
            .safeAreaInset(edge: .leading) { Image(systemName: "magnifyingglass") }
            .padding(.all)
            .background(.gray, in: .capsule)
    }
}
