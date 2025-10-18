//
//  Extensions.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI

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
                .font(.system(size: 12, weight: .light))
            TextField(introduction, text: $promptValue)
                .font(.system(size: 16, weight: .regular))
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
                .font(.system(size: 12, weight: .light))
            SecureField(introduction, text: $promptValue)
                .font(.system(size: 16, weight: .regular))
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
