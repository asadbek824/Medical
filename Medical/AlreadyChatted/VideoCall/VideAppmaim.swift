//
//  VideAppmaim.swift
//  Chat_Doc
//
//  Created by islombek on 15/11/24.
//
import SwiftUI
import StreamVideo
import StreamVideoSwiftUI

struct VideoCallView: View {
    @State private var call: Call
    @ObservedObject private var state: CallState
    @State private var callCreated: Bool = false
    @State private var isMuted: Bool = false
    @State private var isCameraOn: Bool = true
    @State private var isFrontCamera: Bool = true  // Track the current camera (front/back)
    
    private var client: StreamVideo

    private let apiKey: String = "mmhfdzb5evj2"
    private let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL3Byb250by5nZXRzdHJlYW0uaW8iLCJzdWIiOiJ1c2VyL0Rhc2hfUmVuZGFyIiwidXNlcl9pZCI6IkRhc2hfUmVuZGFyIiwidmFsaWRpdHlfaW5fc2Vjb25kcyI6NjA0ODAwLCJpYXQiOjE3MzE2NTExMzMsImV4cCI6MTczMjI1NTkzM30.2TssuMPoVWwNHEQz86KvDSAf0Cdjxw_2JR0G41nkqK4"
    private let userId: String = "Dash_Rendar"
    private let callId: String = "HJbcME4wRY7s"

    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>

    init() {
        let user = User(
            id: userId,
            name: "Martin",
            imageURL: .init(string: "https://static.tuit.uz/uploads/1/W73eM8T-hn5cLRoa_rQWKshn3eUutXvm.png")
        )
        
        self.client = StreamVideo(
            apiKey: apiKey,
            user: user,
            token: .init(stringLiteral: token)
        )

        let call = client.call(callType: "default", callId: callId)
        self.call = call
        self.state = call.state
    }

    var body: some View {
        VStack {
            if callCreated {
                ZStack {
                    // Background Gradient
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                    
                    // Video participants view
                    ParticipantsView(
                        call: call,
                        participants: call.state.remoteParticipants,
                        onChangeTrackVisibility: { participant, isVisible in
                            Task {
                                if let participant = participant {
                                    await call.changeTrackVisibility(for: participant, isVisible: isVisible)
                                }
                            }
                        }
                    )
                    
                    // Local participant view
                    if let localParticipant = call.state.localParticipant {
                        FloatingParticipantView(participant: localParticipant, size: CGSize(width: 100, height: 150))
                    }
                    
                    // Floating Control Buttons
                    VStack {
                        Spacer()
                        HStack {
                            // Mute Button
                            Button(action: {
                                isMuted.toggle()
                              
                            }) {
                                Image(systemName: isMuted ? "mic.slash.fill" : "mic.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .shadow(radius: 10)
                            }

                            // Camera Toggle Button (Front/Back)
                            Button(action: {
                                isFrontCamera.toggle()
                              
                            }) {
                                Image(systemName: isFrontCamera ? "camera.rotate" : "camera.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .shadow(radius: 10)
                            }

                            // Camera Toggle On/Off Button
                            Button(action: {
                                isCameraOn.toggle()
                                // Toggle video track
                
                            }) {
                                Image(systemName: isCameraOn ? "camera.fill" : "camera.slash.fill")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .shadow(radius: 10)
                            }

                            // End Call Button
                            Button(action: {
                                call.leave() // Leave the call
                                presentationMode.wrappedValue.dismiss() // Close the view
                            }) {
                                Image(systemName: "phone.down.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(Circle().fill(Color.black.opacity(0.6)))
                                    .shadow(radius: 10)
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
            } else {
                VStack {
                    Text("Loading...")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                }
            }
        }
        .onAppear {
            Task {
                // Join the call when the view appears
                guard callCreated == false else { return }
                do {
                    try await call.join(create: true)
                    callCreated = true
                } catch {
                    // Handle error gracefully
                    print("Error joining call: \(error)")
                }
            }
        }
        .navigationBarBackButtonHidden(true) // Optional: Hide back button if needed
    }
}

struct VideoCallView_Previews: PreviewProvider {
    static var previews: some View {
        VideoCallView()
    }
}
