//
//  MessageBuble.swift
//  Chat_Doc
//
//  Created by islombek on 15/11/24.
//

import SwiftUI
import Foundation

struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                Image(systemName: "checkmark")
                    .font(.footnote)
                    .foregroundColor(.blue)
            } else {
                VStack(alignment: .leading) {
                    Text(message.text)
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(20)
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct Message: Identifiable, Codable {
    var id = UUID()
    let text: String
    let isFromUser: Bool
}

