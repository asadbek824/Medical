//
//  AIChatViewModel.swift
//  AIChat
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import SwiftUI

final class AIChatViewModel: ObservableObject {
    
    @Published var messages: [ChatMessage] = []
    
    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        let userMessage = ChatMessage(text: text, isUserMessage: true)
        messages.append(userMessage)
        
        // Simulate AI response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responseMessage = ChatMessage(text: "AI Response to: \(text)", isUserMessage: false)
            self.messages.append(responseMessage)
        }
    }
}
