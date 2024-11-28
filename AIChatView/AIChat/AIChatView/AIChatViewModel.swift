//
//  AIChatViewModel.swift
//  AIChat
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import SwiftUI
import NetworkManager

final class AIChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var messageText: String = ""
    @Published var isTyping: Bool = false

    private let defaultResponses = [
        "Sorry, I didn't quite catch that. Can you ask differently?",
        "Hmm, interesting! Let me think about it...",
        "I'm here to help, but I may need more details.",
        "That's a great question, but I'm not sure. Maybe try rephrasing?"
    ]

    private let predefinedResponses: [String: String] = [
        // Приветствия
        "привет": "Привет! Чем могу помочь?",
        "здравствуйте": "Здравствуйте! Как я могу вам помочь?",
        "добрый день": "Добрый день! Чем могу быть полезен?",
        "hello": "Hello! How can I assist you?",
        
        // Общие вопросы
        "как дела": "У меня все отлично, спасибо, что спросили!",
        "как ты": "Я программа, так что чувствую себя отлично!",
        "чем занимаешься": "Отвечаю на ваши вопросы!",
        
        // О программе
        "что ты умеешь": "Я могу отвечать на вопросы, помогать в приложении и просто поддерживать беседу.",
        "ты настоящий": "Нет, я искусственный интеллект. Но могу показаться очень умным :)",
        "что ты знаешь": "Я знаю много, но всё зависит от того, что вы спросите.",
        
        // Простые темы
        "какая сегодня погода": "К сожалению, я не могу проверить погоду, но вы можете использовать приложение для этого.",
        "сколько времени": "Время уточнить вы можете на вашем устройстве :)",
        "расскажи шутку": "Почему компьютер пошел в бар? Ему нужно было больше памяти!",
        
        // Научные вопросы
        "что такое искусственный интеллект": "Искусственный интеллект — это технология, которая позволяет машинам думать и учиться, как люди.",
        "что такое квантовая физика": "Квантовая физика изучает поведение частиц на субатомном уровне.",
        "расскажи про черные дыры": "Чёрные дыры — это области пространства, где гравитация настолько сильна, что даже свет не может их покинуть.",
        
        // Конкретные вопросы
        "как работает интернет": "Интернет — это глобальная сеть, которая соединяет миллиарды устройств, используя протоколы для обмена данными.",
        "что такое днк": "ДНК — это молекула, содержащая генетическую информацию, которая определяет характеристики живых организмов.",
        "что такое swift": "Swift — это язык программирования от Apple для разработки приложений на iOS, macOS и других платформах."
    ]

    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }
        
        // Добавляем сообщение пользователя
        let userMessage = ChatMessage(text: text, isUserMessage: true)
        messages.append(userMessage)
        
        // Показываем индикатор загрузки
        isTyping = true
        
        // Имитация ответа AI
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responseText = self.generateResponse(for: text)
            let responseMessage = ChatMessage(text: responseText, isUserMessage: false)
            self.messages.append(responseMessage)
            self.isTyping = false
        }
    }

    private func generateResponse(for text: String) -> String {
        // Приводим текст в нижний регистр для поиска
        let lowercasedText = text.lowercased()
        
        // Ищем ключевые слова в предопределенных ответах
        for (key, response) in predefinedResponses {
            if lowercasedText.contains(key) {
                return response
            }
        }
        
        // Если ничего не найдено, возвращаем случайный стандартный ответ
        return defaultResponses.randomElement() ?? "Извините, я не понял. Попробуйте задать вопрос по-другому."
    }
}
