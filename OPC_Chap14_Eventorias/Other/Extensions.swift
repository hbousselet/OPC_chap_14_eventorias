//
//  Extensions.swift
//  OPC_Chap14_Eventorias
//
//  Created by Hugues BOUSSELET on 19/09/2025.
//

import Foundation
import SwiftUI

struct CustomPrompt: View {
    var title: String
    @Binding var promptValue: String
    @State var showAlert = false
    let action: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
            TextField("", text: $promptValue)
                .padding()
                .border(.black, width: 2)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .onSubmit {
                    if promptValue.isEmpty {
                        showAlert.toggle()
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alert !"),
                        message: Text("Coucou"),
                        dismissButton: .destructive(Text("Exit")))
                        }
        }
        .padding(.horizontal, 20)
    }
}

struct CustomPassword: View {
    var title: String
    var addForgotPasswordIndication: Bool
    @Binding var promptValue: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
            SecureField("", text: $promptValue)
                .padding()
                .border(.black, width: 2)
            if addForgotPasswordIndication {
                Text("Forgot password ?")
                    .font(.system(.caption2, design: .default, weight: .light))
            }
        }
        .padding(.horizontal, 20)
    }
}

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
        .background(.gray)
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
        .background(.gray)
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
}

extension String {
    func removeSpacesAndLowercase() -> String {
        return self.replacingOccurrences(of: " ", with: "")
                   .lowercased()
    }
}
