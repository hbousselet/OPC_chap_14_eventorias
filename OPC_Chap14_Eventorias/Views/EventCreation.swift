//
//  EventCreation.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 08/10/2025.
//

import SwiftUI

struct EventCreation: View {
    @State private var viewModel: EventCreationViewModel = EventCreationViewModel()
        
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color.customGray.ignoresSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
                        CustoTextfield(title: "Title",
                                       introduction: "New event",
                                       keyboardType: .default,
                                       promptValue: $viewModel.title,
                                       size: CGSize(width: 358, height: 56))
//                        .padding(.top, 12)
                        CustoTextfield(title: "Description",
                                       introduction: "Tap here to enter your description",
                                       keyboardType: .default,
                                       promptValue: $viewModel.description,
                                       size: CGSize(width: 358, height: 56))
//                        .padding(.top, 12)
                        HStack {
                            CustoTextfield(title: "Date",
                                           introduction: "MM/DD/YYYY",
                                           keyboardType: .default,
                                           promptValue: $viewModel.date,
                                           size: CGSize(width: 176, height: 56))
                            CustoTextfield(title: "Time",
                                           introduction: "HH : MM",
                                           keyboardType: .default,
                                           promptValue: $viewModel.time,
                                           size: CGSize(width: 176, height: 56))
                        }
//                        .padding(.top, 12)
                        CustoTextfield(title: "Address",
                                       introduction: "Enter full address",
                                       keyboardType: .default,
                                       promptValue: $viewModel.address,
                                       size: CGSize(width: 358, height: 56))
                        HStack {
                            cameraButton
                            pictureButton
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            HStack(alignment: .center) {
                                Text("Validate")
                                    .foregroundStyle(.white)
                            }
                            .frame(width: 358, height: 52)
                            .background(.red)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 180)
                .ignoresSafeArea(edges: .top)
            }
            .navigationTitle("Creation of an Event")
        }
    }
    
    private var cameraButton: some View {
        Button {
            
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "camera")
                    .foregroundStyle(.black)
            }
            .frame(width: 52, height: 52)
            .background(.white, in: RoundedRectangle(cornerRadius: 12))
        }
    }
    
    private var pictureButton: some View {
        Button {
            
        } label: {
            HStack(alignment: .center) {
                Image(systemName: "paperclip")
                    .rotationEffect(Angle(degrees: -45))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            .background(.red, in: RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
//    @Previewable @State var eventsViewModel: EventsViewModel = .init(event: [])
    EventCreation()
}
