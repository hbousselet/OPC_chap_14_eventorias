//
//  EventsList.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import SwiftUI

struct EventsList: View {
    @Environment(EventsViewModel.self) private var viewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
            Color.black.ignoresSafeArea(.all)
            ScrollView {
                ZStack(alignment: .bottomTrailing) {
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: 56, height: 56)
                            .foregroundStyle(.red)
                            .overlay {
                                Image(systemName: "plus")
                                    .foregroundStyle(.white)
                                    .background(.red)
                            }
                    }
                    .glassEffect(.clear)
                    .zIndex(2)
                    VStack(alignment: .leading) {
                        CustomTextField(viewModel: viewModel)
                        sortingCapsule()
                        ForEach(viewModel.events, id: \.id) { event in
                            eventElement(event, with: geometry.size)
                                .frame(width: geometry.size.width * 0.9, height: 80)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .zIndex(1)
                }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchEvents()
        }
    }
    
    private func eventElement(_ event: EventModel, with size: CGSize) -> some View {
        HStack {
            image(with: event.profil?.icon, size: CGSize(width: 40.0, height: 40.0))
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
            image(with: event.image, size: CGSize(width: 136.0, height: 80.0))
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
                   .onAppear {
                       print("url: \(String(describing: url))")

                   }
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

//#Preview {
//    @Previewable @State var eventViewModel: EventsViewModel = EventsViewModel(event: [EventModel(id: UUID(),name: "Sisyphos",
//                                                                                                 description: "refouler",
//                                                                                                 date: Date.now,
//                                                                                                 user: "Terminando",
//                                                                                                 address: Address(latitude: 48.0, longitude: 12.3),
//                                                                                                 image: URL(string: "https://img.lemde.fr/2025/09/30/0/0/0/0/994/0/75/0/49de171_ftp-import-images-1-0avesfp6jmif-2025-09-30t133128z-719127529-rc2y0hatqelm-rtrmadp-3-israel-palestinians-jordan-aid.JPG"),
//                                                                                                 profil: User(name: "Peter", email: "maltSale@gmail.com", icon: "https://img.lemde.fr/2025/09/30/0/0/5346/2673/2000/1000/75/0/a2f2905_ftp-import-images-1-k6spoxbmx1pw-3d5c55f07c40490eb7985fd3b7f43e17-0-faeaf65134ef4ed99a5318b8a7bd354c.jpg", notification: true)), ])
//
//    EventsList()
//        .environment(eventViewModel)
//    
//}

