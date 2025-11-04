//
//  Extensions.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct CustoTextfield: View {
    var title: String
    var introduction: String
    var isEditable: Bool = true
    let keyboardType: UIKeyboardType
    @Binding var promptValue: String
    let size: CGSize
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Inter_18pt-Regular", size: 12))
            TextField(introduction, text: $promptValue)
                .font(.custom("Inter_18pt-Regular", size: 16))
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .onSubmit {
                }
        }
        .padding(.top, 8)
        .padding(.bottom, 10)
        .padding(.leading, 16)
        .frame(width: size.width, height: size.height)
        .background(Color.textfieldBackground)
        .accessibilityElement(children: .combine)
    }
}

struct CustomImage: View {
    let url: URL?
    let size: CGSize
    var isPortrait: Bool = false
    
    var body: some View {
        WebImage(url: url) { image in
            image.resizable()
        } placeholder: {
            if isPortrait {
                Image("portrait-placeholder")
            } else {
                Image("image-placeholder")
            }
        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5))
        .scaledToFill()
        .frame(width: max(0, size.width.isFinite ? size.width : 0), 
               height: max(0, size.height.isFinite ? size.height : 0))
    }
}

struct CustoTextfieldPassword: View {
    var title: String
    var introduction: String
    var isEditable: Bool = true
    let keyboardType: UIKeyboardType
    @Binding var promptValue: String
    let size: CGSize
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Inter_18pt-Regular", size: 12))
            SecureField(introduction, text: $promptValue)
                .font(.custom("Inter_18pt-Regular", size: 16))
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(keyboardType)
                .onSubmit {
                }
        }
        .padding(.top, 8)
        .padding(.bottom, 10)
        .padding(.leading, 16)
        .frame(width: size.width, height: size.height)
        .background(Color.textfieldBackground)
        .accessibilityElement(children: .combine)
    }
}

extension Binding where Value == Bool {
    var not: Binding<Bool> {
        Binding<Bool>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}

extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
    static let textfieldBackground = Color(UIColor(cgColor: CGColor(red: 73/255, green: 69/255, blue: 79/255, alpha: 1)))
}

extension String {
    func removeSpacesAndLowercase() -> String {
        return self.replacingOccurrences(of: " ", with: "")
                   .lowercased()
    }
}
