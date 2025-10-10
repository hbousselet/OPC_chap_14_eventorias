//
//  EventsViewModel.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import FirebaseStorage
import CoreLocation
import UIKit

@Observable class EventsViewModel {
    var events: [EventModel] = []
    var search: String = ""
    var signOut: Bool = false
    
    let imageLoader = ImageLoader.shared
    
    init(event: [EventModel]) {
        self.events = events
    }
    
    func fetchEvents() async {
        do {
            let firestoreEvents = try await Event.fetchEvents()
            var convertedEvents: [EventModel] = firestoreEvents.compactMap { $0.convert() }
            
            for (index, event) in convertedEvents.enumerated() {
                await imageLoader.downloadImageInStorage(from: event.image, with: event.name.removeSpacesAndLowercase())
                guard let userid = event.user else { continue }
                let user = try await User.fetchUser(userid)
                convertedEvents[index].profil = user
                await imageLoader.downloadImage(from: user.icon, with: user.email)
            }
            events = convertedEvents
        } catch {
            print("error : \(error)")
        }
    }
    
    func getImage(name: String) -> UIImage {
        print("get image for : \(name)")
        if let cachedImage = ImageLoader.shared.getImage(forKey: name) {
            print("could get the image")
            return cachedImage
        }
        print("not able to get the image")
        return UIImage(named: "placeholder-rectangle")!
    }
    
}

class ImageLoader {
    static let shared = ImageLoader()
    
    var currentState: ImageState = .initialisation
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        print("### we store image name : \(key)")
        cache.setObject(image, forKey: key as NSString)
    }
    
    func downloadImage(from url: URL?, with name: String) async {
        currentState = .loading
        guard let url else { return }
        do {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let response = try await URLSession(configuration: .default).data(for: request)
            let uiImage = UIImage(data: response.0)
            guard let uiImage else {
                currentState = .error
                return }
            currentState = .loaded(uiImage)
            setImage(uiImage, forKey: name)
        } catch {
            currentState = .error
            print("error : \(error)")
        }
    }
    
    func downloadImageInStorage(from path: String, with name: String) async {
        let imageRef = Storage.storage().reference().child("images/\(path).jpg")
        do {
            let imageData = try await imageRef.data(maxSize: 1 * 1024 * 1024)
            guard let uiImage = UIImage(data: imageData) else { return }
            self.setImage(uiImage, forKey: name)
        } catch {
            print("error")
        }
        
    }
    
}

enum ImageState {
    case initialisation
    case loading
    case loaded(UIImage)
    case error
}
    
extension String {
    func removeSpacesAndLowercase() -> String {
        return self.replacingOccurrences(of: " ", with: "")
                   .lowercased()
    }
}
