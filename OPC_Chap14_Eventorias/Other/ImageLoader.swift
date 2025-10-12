//
//  ImageLoader.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 12/10/2025.
//

import Foundation
import FirebaseStorage
import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}

    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
    
    func downloadImage(from url: URL?, with name: String) async throws {
        guard let url else { return }
        do {
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let response = try await URLSession(configuration: .default).data(for: request)
            let uiImage = UIImage(data: response.0)
            guard let uiImage else {
                return }
            setImage(uiImage, forKey: name)
        } catch {
            print("error : \(error)")
            throw EventsAlert.notAbleToLoadUserImage(error: error)
        }
    }
    
    func downloadImageInStorage(from path: String, with name: String) async throws {
        let imageRef = Storage.storage().reference().child("images/\(path).jpg")
        do {
            let imageData = try await imageRef.data(maxSize: 1 * 3024 * 4032)
            guard let uiImage = UIImage(data: imageData) else { return }
            self.setImage(uiImage, forKey: name)
        } catch {
            print("error can't load image: \(error)")
            throw EventsAlert.notAbleToDownloadImage(error: error)
        }
        
    }
    
}
