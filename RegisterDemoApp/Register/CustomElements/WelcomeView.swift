//
//  WelcomeView.swift
//  Register
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Core

struct WelcomeView: View {
    
    var title: String
    var description: String
    
    var body: some View {
        contentView()
    }
}

extension WelcomeView {
    
    @ViewBuilder
    func contentView() -> some View {
        VStack(spacing: 12.dpHeight()) {
            Text(title.uppercased())
                .font(.sabFont(700, size: 30))
                .foregroundColor(.customNavy) // Цвет заголовка
                .minimumScaleFactor(0.6)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            Text(description)
                .font(.sabFont(500, size: 14))
                .foregroundColor(.customNavy) // Цвет описания
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
