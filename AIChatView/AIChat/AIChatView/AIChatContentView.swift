//
//  AIChatContentView.swift
//  AIChat
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import SwiftUI
import Core

// MARK: - Основной View
public struct AIChatContentView: View {
    @StateObject private var viewModel = AIChatViewModel()
    
    public init() { }
    
    public var body: some View {
        contentView()
            .chatBackground()
    }
}

// MARK: - Расширение для View
extension AIChatContentView {
    @ViewBuilder
    func contentView() -> some View {
        VStack(spacing: .zero) {
            if !viewModel.messages.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.isUserMessage {
                                    Spacer()
                                    Text(message.text)
                                        .messageStyle(isUserMessage: true)
                                } else {
                                    Text(message.text)
                                        .messageStyle(isUserMessage: false)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal, 16.dpWidth())
                            .transition(.slide)
                            .animation(.easeInOut(duration: 0.3), value: viewModel.messages)
                        }
                    }
                }
                .padding(.vertical)
            }
            
            Spacer()
            
            if viewModel.messages.isEmpty {
                Text("Ask your questions to AI here!".uppercased())
                    .font(.sabFont(700, size: 19))
                    .foregroundColor(Color.customDarkBlue)
                    .padding(.bottom, 16.dpHeight())
            }
            
            if viewModel.isTyping {
                HStack {
                    Spacer()
                    Text("AI is typing...")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            HStack(spacing: 8.dpWidth()) {
                TextField("Type a message", text: $viewModel.messageText)
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20.dpHeight())
                            .stroke(Color.customDarkBlue, lineWidth: 2)
                    )
                    .frame(height: 40.dpHeight())
                
                Button(action: {
                    viewModel.sendMessage(viewModel.messageText)
                    viewModel.messageText = ""
                }) {
                    Text("SEND")
                        .frame(maxHeight: 40.dpHeight())
                        .padding(.horizontal, 16.dpWidth())
                        .background(Color.customDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(20.dpHeight())
                }
                .disabled(viewModel.messageText.isEmpty)
                .opacity(viewModel.messageText.isEmpty ? 0.5 : 1)
            }
            .padding(.horizontal, 16.dpWidth())
            .padding(.bottom, 16.dpHeight())
        }
        .frame(maxHeight: viewModel.messages.isEmpty ? .infinity : nil)
    }
}

extension View {
    func chatBackground() -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: [Color.customLightBlue, Color.customPalePink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

extension Text {
    func messageStyle(isUserMessage: Bool) -> some View {
        self.padding()
            .background(isUserMessage ? Color.customDarkBlue : Color.customDarkBlue.opacity(0.3))
            .foregroundColor(isUserMessage ? .white : Color.customNavy)
            .cornerRadius(16)
            .frame(maxWidth: 250.dpWidth(), alignment: isUserMessage ? .trailing : .leading)
            .multilineTextAlignment(isUserMessage ? .trailing : .leading)
    }
}
