//
//  MessageInpit.swift
//  Chat_Doc
//
//  Created by islombek on 15/11/24.
//

import SwiftUI
import Foundation

struct MessageInputField: View {
    @Binding var messageText: String
    let onSend: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                // Attachments action
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            }
            .padding(.horizontal, 4)

            TextField("Write a message...", text: $messageText)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(20)

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(messageText.isEmpty ? .blue : .gray)
            }
            .disabled(messageText.isEmpty)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(radius: 2)
    }
}
