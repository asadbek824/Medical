//
//  ChatMessageModel.swift
//  AIChat
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import Foundation

struct ChatMessage: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let isUserMessage: Bool
}
