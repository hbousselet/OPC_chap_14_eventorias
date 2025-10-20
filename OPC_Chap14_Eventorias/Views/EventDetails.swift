//
//  EventDetails.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 02/10/2025.
//

import SwiftUI
import UIKit
import MapKit

struct EventDetails: View {
    var event: EventModel
    @State var eventPlace: MKMapItem?
    @State private var cameraPosition: MapCameraPosition = .automatic

    @Environment(EventsViewModel.self) private var viewModel
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                Color.systemBackground.ignoresSafeArea(.all)
                ScrollView {
                    VStack(alignment: .leading) {
                        CustomImage(url: event.imageUrl, size: CGSize(width: geometry.size.width - 32, height: geometry.size.height / 3))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        dateInfo
                            .padding(.top)
                        eventDescription
                            .padding(.top, 5)
                        addressInfo
                            .padding(.top, 5)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 120)
                .ignoresSafeArea(edges: .top)
            }
        }
        .task {
            if let request = MKReverseGeocodingRequest(location:
                                                        CLLocation(latitude: event.address.latitude,
                                                                   longitude: event.address.longitude)) {
                let mapitems = try? await request.mapItems
                if let mapitem = mapitems?.first {
                    eventPlace = mapitem
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .title) {
                Text(event.name)
                    .font(.custom("Inter_18pt-Medium", size: 20))
            }
        }
    }
    
    var dateInfo: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "calendar.badge")
                    Text(event.date, format: .dateTime.month(.abbreviated).year().day())
                }
                HStack {
                    Image(systemName: "clock")
                    Text(event.date, formatter: timeFormatter)
                }
            }
            .font(.custom("Inter_18pt-Medium", size: 16))
            Spacer()
            CustomImage(url: event.profil?.icon, size: CGSize(width: 60, height: 60), isPortrait: true)
                .clipShape(Circle())
        }
    }
    
    var eventDescription: some View {
        Text(event.description)
            .font(.custom("Inter_18pt-Regular", size: 14))
    }
    
    var addressInfo: some View {
        HStack {
            if let address = eventPlace?.address?.fullAddress {
                Text(address)
                    .lineLimit(3)
                    .font(.custom("Inter_18pt-Medium", size: 16))
            } else {
                Text("No address available")
            }
            Spacer()
            showMap()
        }
    }
    
    func showMap() -> some View {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: event.address.latitude,
                longitude: event.address.longitude
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01  
            )
        )
        
        return Map(position: .constant(.region(region))) {
            Annotation(event.name,
                       coordinate: CLLocationCoordinate2D(latitude: event.address.latitude, longitude: event.address.longitude), content: {
                ZStack {
                    Image(systemName: "mappin")
                        .padding(8)
                }
            })
        }
        .mapControlVisibility(.hidden)
        .mapStyle(.standard(elevation: .realistic))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .frame(width: 149, height: 72)
    }
}
