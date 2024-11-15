//
//  PrimeryTextField.swift
//  RegistrationFramework
//
//  Created by Asadbek Yoldoshev on 25/10/24.
//

import SwiftUI
import Core

enum KeyboardType {
    case emailAddress
    case numberPad
    case alphabet
    case decimalPad
    case phonePad
    case URL
    case asciiCapable
    case asciiCapableNumberPad
    case default1
    case namePhonePad
    case numbersAndPunctuation
    
    var getKeyboardType: UIKeyboardType {
        switch self {
        case .emailAddress:
            return .emailAddress
        case .numberPad:
            return .numberPad
        case .alphabet:
            return .alphabet
        case .decimalPad:
            return .decimalPad
        case .phonePad:
            return .phonePad
        case .URL:
            return .URL
        case .asciiCapable:
            return .asciiCapable
        case .asciiCapableNumberPad:
            return .asciiCapableNumberPad
        case .default1:
            return .default
        case .namePhonePad:
            return .namePhonePad
        case .numbersAndPunctuation:
            return .numbersAndPunctuation
        }
    }
}

struct PrimeryTextField: View {
    @EnvironmentObject var vm: RegisterViewModel
    @Binding var textFiledText: String
    @Binding var keyboardType: KeyboardType
    @State var placeholderText: String
    @State var textFieldIsEditing: Bool = false
    @State var imageIsHidden: Bool = false
    @State var eyeSeeOrNotSee: Bool = true
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            Text(placeholderText)
                .foregroundColor(.gray)
                .font(.sabFont(400, size: textFieldIsEditing || !textFiledText.isEmpty ? 11 : 16))
                .offset(y: textFieldIsEditing || !textFiledText.isEmpty ? -24 : 0)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: true, vertical: false)
                
            TextField("", text: $textFiledText, onEditingChanged: { editing in
                withAnimation(.easeInOut(duration: 0.5)) {
                    textFieldIsEditing = editing
                }
            })
            .focused($isTextFieldFocused)
            .textFieldStyle(.plain)
            .keyboardType(keyboardType.getKeyboardType)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.customLightBlue), // Линия под текстовым полем
                alignment: .bottom
            )
            .frame(height: 50.dpHeight())
        }
    }
}
