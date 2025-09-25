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
                Color.black.ignoresSafeArea(.all)
                VStack(alignment: .leading) {
                    CustomTextField(viewModel: viewModel)
                    sortingCapsule()
                    ScrollView {
                        VStack {
                            ForEach(viewModel.events, id: \.id) { event in
                                eventElement(event)
                            }
                        }
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 20)
                
            }
            .task {
                await viewModel.fetchEvents()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.logout()
                    } label: {
                        Label("LogOut", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                    .foregroundStyle(.white)
                }
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.signOut },
                set: { viewModel.signOut = $0 }
            )) {
                LoginView()
            }
    }
    
    private func eventElement(_ event: EventModel) -> some View {
        HStack {
            AsyncImage(url: event.image)
                .frame(width: 20, height: 20)
            VStack {
                Text(event.title)
                Text(event.date, style: .date)
            }
            .onAppear {
                print("event : \(event)")
            }
        }
        .foregroundStyle(.white)
    }
    
    private func sortingCapsule() -> some View {
        Button {
            
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

#Preview {
    @Previewable @State var eventViewModel: EventsViewModel = EventsViewModel()

    EventsList()
        .environment(eventViewModel)
}
