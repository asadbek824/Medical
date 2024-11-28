//
//  DoctorChat.swift
//  Chat_Doc
//
//  Created by islombek on 14/11/24.
//
import SwiftUI

struct ChatWithDoctorsView: View {
    @State var doctor: Doctor
    @State private var messageText = ""
    @State private var messages: [Message]
    @State private var isTyping = false
    @State private var isVideoCallPresented = false
    @State private var isDoctorProfilePresented = false

    // Add state to trigger the full-screen ConsultationView
    @State private var showConsultationView = false

    let chatStorage = ChatStorageManager()

    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var appointmentData: AppointmentData

    // Updated initializer
    init(doctor: Doctor, initialMessages: [Message], appointmentData: AppointmentData) {
        self.doctor = doctor
        self._messages = State(initialValue: initialMessages)
        self.appointmentData = appointmentData
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header with Doctor Info
            HStack {
                Button(action: {
                    saveChatData()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                Spacer()

                Button(action: {
                    // Set to true to present ConsultationView in full screen
                    showConsultationView.toggle()
                }) {
                    HStack(spacing: 12) {
                        Image(doctor.imageName)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                            .shadow(radius: 5)

                        VStack(alignment: .leading) {
                            Text(doctor.name)
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text(doctor.specialty)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 20) {
                    // Phone call button action
                    Button(action: {
                        makePhoneCall(to: "+998975450428")
                    }) {
                        Image(systemName: "phone.fill")
                            .font(.title2)
                            .foregroundColor(.green)
                    }

                    Button(action: {
                        isVideoCallPresented.toggle()
                    }) {
                        Image(systemName: "video.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .padding(.horizontal)

            // Chat Messages
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                        }

                        if isTyping {
                            Text("Dr \(doctor.name) is typing...")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }

            // Message Input Area
            MessageInputField(messageText: $messageText, onSend: sendMessage)
                .padding(.horizontal)
                .background(Color.customPalePink)
        }
        .navigationBarHidden(true)
        .background(Color.customPalePink.ignoresSafeArea())
        .fullScreenCover(isPresented: $isVideoCallPresented) {
            VideoCallView()
        }
        // Present the ConsultationView in full screen when the state is true
        .fullScreenCover(isPresented: $showConsultationView) {
            ConsultationView()
        }
        .onAppear {
            self.messages = chatStorage.loadChat(for: doctor.id)
//            sendAutomaticWelcomeMessageIfNeeded()
//            sendAutomaticMessage()
            if !appointmentData.fullName.isEmpty && !appointmentData.selectedAgeGroup.isEmpty && !appointmentData.problemDescription.isEmpty && !appointmentData.selectedGender.isEmpty {
                let formattedMessage = "Hi, I'm\(appointmentData.fullName) && , I am\(appointmentData.selectedAgeGroup) && \(appointmentData.problemDescription) && for\(appointmentData.selectedGender)"
                
                let appointmentMessage = Message(text: formattedMessage, isFromUser: true)
                messages.append(appointmentMessage)
                appointmentData.fullName = ""
                appointmentData.problemDescription = ""
                appointmentData.selectedAgeGroup = ""
                appointmentData.selectedGender = ""
            }
        }
    }

    private func sendMessage() {
        guard !messageText.isEmpty else { return }

        let newMessage = Message(text: messageText, isFromUser: true)
        messages.append(newMessage)
        messageText = ""

        isTyping = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responseMessage = simulateDoctorResponse(to: newMessage)
            messages.append(responseMessage)
            isTyping = false
        }
    }

    private func simulateDoctorResponse(to newMessage: Message) -> Message {
        let responseMessage: Message

        if newMessage.text.lowercased().contains("hello") || newMessage.text.lowercased().contains("hi") {
            responseMessage = Message(
                text: "Hello! I'm here to assist you. How can I help you today?",
                isFromUser: false
            )
        } else {
            responseMessage = Message(
                text: "I'm here to help! Could you provide more details about what you're experiencing or ask me a specific question?",
                isFromUser: false
            )
        }

        return responseMessage
    }

    private func saveChatData() {
        chatStorage.saveChat(for: doctor.id, messages: messages)
    }

    private func makePhoneCall(to number: String) {
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
