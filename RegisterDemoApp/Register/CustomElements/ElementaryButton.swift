//
//  ElementaryButton.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Core

struct ElementaryButton: View {
    
    var elementaryButtonText: String
    var disabled: Bool = false
    var action: () -> ()
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(elementaryButtonText)
                .font(.sabFont(600, size: 16))
                .frame(height: 54.dpHeight())
                .frame(maxWidth: .infinity)
                .background(disabled ? Color.customLightBlue : Color.customDarkBlue) // Цвет кнопки
                .foregroundColor(disabled ? Color.customNavy : Color.white) // Цвет текста на кнопке
                .cornerRadius(10.dpHeight())
                .opacity(disabled ? 0.6 : 1.0)
        }
        .disabled(disabled)
    }
}
