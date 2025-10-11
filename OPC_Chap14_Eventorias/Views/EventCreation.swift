//
//  EventCreation.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 08/10/2025.
//

import SwiftUI
import PhotosUI

struct EventCreation: View {
    @Binding var isPresented: Bool
    @State private var viewModel: EventCreationViewModel = EventCreationViewModel()
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImageData: Data?
    @State private var selectedtype: EventType?
    var body: some View {
        ZStack(alignment: .top) {
            Color.customGray
                .ignoresSafeArea(.all)
            ScrollView {
                VStack {
                    CustoTextfield(title: "Title",
                                   introduction: "New event",
                                   keyboardType: .default,
                                   promptValue: $viewModel.title,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, .topPadding)
                    CustoTextfield(title: "Description",
                                   introduction: "Tap here to enter your description",
                                   keyboardType: .default,
                                   promptValue: $viewModel.description,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, .topPadding)
                    HStack(alignment: .center) {
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
                    .padding(.top, .topPadding)
                    CustoTextfield(title: "Address",
                                   introduction: "Enter full address",
                                   keyboardType: .default,
                                   promptValue: $viewModel.address,
                                   size: CGSize(width: 358, height: 56))
                    .padding(.top, .topPadding)
                    Picker("Event type", selection: $viewModel.type) {
                        ForEach(EventType.allCases) { type in
                            Text(type.rawValue)
                                .tag(type.id)
                        }
                    }
                    .pickerStyle(.inline)
                    .frame(width: 358, height: 56)
                    .background(.gray)
                    .padding(.top, .topPadding)
                    HStack(alignment: .center) {
                        cameraButton
                        pictureButton
                    }
                    .padding(.top, 48)
                }
                .padding(.horizontal, 16)
                .padding(.bottom)
            }
            .padding(.top, 180)
            .ignoresSafeArea(edges: .top)
        }
        .navigationTitle("Creation of an Event")
        .safeAreaInset(edge: .bottom) {
            validateButton
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
        }
        .onChange(of: pickerItem) {
            Task {
                viewModel.selectedImage = try await pickerItem?.loadTransferable(type: Data.self)
            }
        }
        .onChange(of: viewModel.dismiss) { newValue in
            if newValue == true {
                isPresented = false
            }
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
        PhotosPicker(selection: $pickerItem, matching: .images,
                     label: {
            HStack(alignment: .center) {
                Image(systemName: "paperclip")
                    .rotationEffect(Angle(degrees: -45))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            .background(.red, in: RoundedRectangle(cornerRadius: 12))
        })
    }
    
    private var validateButton: some View {
        Button {
            Task {
                await viewModel.createEvent()
            }
        } label: {
            HStack(alignment: .center) {
                Text("Validate")
                    .foregroundStyle(.white)
            }
            .frame(width: 358, height: 52)
            .background(.red)
        }
    }
}

private extension CGFloat {
    static let topPadding: CGFloat = 8
}
