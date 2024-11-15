//
//  AIChatContentView.swift
//  AIChat
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import SwiftUI
import Core

public struct AIChatContentView: View {
    
    @StateObject private var viewModel = AIChatViewModel()
    @State private var messageText: String = ""
    
    public init() { }
    
    public var body: some View {
        contentView()
    }
}

extension AIChatContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        VStack(spacing: .zero) {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(viewModel.messages, id: \.id) { message in
                        HStack {
                            if message.isUserMessage {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.customDarkBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                                    .frame(maxWidth: 250, alignment: .trailing)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.customPalePink)
                                    .foregroundColor(Color.customNavy)
                                    .cornerRadius(16)
                                    .frame(maxWidth: 250, alignment: .leading)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 16.dpWidth())
                    }
                }
            }
            .padding(.vertical)
            .background(Color.customPalePink)
            
//            Divider()
//                .background(Color.customDarkBlue.opacity(0.5))
            
            HStack(spacing: .zero) {
                TextField("Type a message", text: $messageText)
                    .padding(10)
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(8)
                
                Button(action: {
                    viewModel.sendMessage(messageText)
                    messageText = ""
                }) {
                    Text("SEND")
                        .foregroundColor(.customDarkBlue)
                        .padding()
                        .background(Color.customLightBlue)
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 16.dpWidth())
        }
    }
}

