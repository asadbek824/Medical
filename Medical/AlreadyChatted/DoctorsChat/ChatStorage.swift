//
//  ChatStorage.swift
//  Chat_Doc
//
//  Created by islombek on 15/11/24.
//

import Foundation

// Define the Message model

class ChatStorageManager {
    
    // Save chat data for a particular doctor
    func saveChat(for doctorId: UUID, messages: [Message]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(messages) {
            UserDefaults.standard.set(encoded, forKey: "chat_\(doctorId.uuidString)")
        }
    }
    
    // Load chat data for a particular doctor
    func loadChat(for doctorId: UUID) -> [Message] {
        guard let savedChat = UserDefaults.standard.data(forKey: "chat_\(doctorId.uuidString)") else {
            return []  // No chat saved for this doctor
        }
        
        let decoder = JSONDecoder()
        if let decodedMessages = try? decoder.decode([Message].self, from: savedChat) {
            return decodedMessages
        }
        
        return []  // If decoding fails, return an empty array
    }
}
