//
//  SecureTextField.swift
//  RegistrationFramework
//
//  Created by Asadbek Yoldoshev on 28/10/24.
//

import SwiftUI
import Core

struct SecureTextField: View {
    @Binding var text: String
    @State private var isTextVisible: Bool = false
    @State private var isEditing: Bool = false
    var placeholder: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        ZStack(alignment: .trailing) {
            if isTextVisible {
                TextField(placeholder, text: $text, onEditingChanged: { editing in
                    isEditing = editing
                })
                .keyboardType(keyboardType)
                .textFieldStyle(.plain)
                .padding(.trailing, 30)
                .frame(height: 44.dpHeight())
            } else {
                SecureField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textFieldStyle(.plain)
                    .padding(.trailing, 30)
                    .frame(height: 44.dpHeight())
            }

            Button(action: {
                isTextVisible.toggle()
            }) {
                Image(systemName: isTextVisible ? "eye.slash" : "eye")
                    .foregroundColor(.customNavy) // Цвет иконки "глаз"
            }
            .padding(.trailing, 8)
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.customLightBlue), // Линия под текстовым полем
            alignment: .bottom
        )
    }
}
