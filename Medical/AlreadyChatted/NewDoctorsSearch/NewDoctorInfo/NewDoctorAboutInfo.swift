//
//  NewDoctorAboutInfo.swift
//  Chat_Doc
//
//  Created by islombek on 16/11/24.
//

import SwiftUI

struct NewDoctorProfileView: View {
    @Environment(\.dismiss) private var dismiss
    var newDoctor: NewDoctor
    
    @ObservedObject var appointmentData: AppointmentData
    var switchToDoctorsView: () -> Void

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Profile Header
                    VStack(spacing: 8) {
                        Image(newDoctor.imageName)  // Ensure NewDoctor model has imageName property
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .overlay(Circle().stroke(Color.customLightBlue, lineWidth: 4))

                        Text(newDoctor.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.customNavy)

                        Text(newDoctor.specialty)
                            .font(.headline)
                            .foregroundColor(.customDarkBlue)
                        
                        Text("\(newDoctor.rating, specifier: "%.1f") ⭐ (\(newDoctor.reviews) reviews)")
                            .font(.subheadline)
                            .foregroundColor(.customLightBlue)
                    }
                    .padding(.top, 16)

                    Divider()
                        .padding(.horizontal)

                    // About Doctor Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Doctor")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.customNavy)

                        Text(newDoctor.aboutDoctor)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)

                    Divider()
                        .padding(.horizontal)

                    // Communication Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Communication")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.customNavy)

                        CommunicationOptionView(imageName: "message.fill", title: "Messaging", description: "Chat me up, share photos.")
                        CommunicationOptionView(imageName: "phone.fill", title: "Audio Call", description: "Call your doctor directly.")
                        CommunicationOptionView(imageName: "video.fill", title: "Video Call", description: "See your doctor live.")
                    }
                    .padding(.horizontal)

                    Spacer()

                    // Navigate to PatientDetailView
                    NavigationLink(destination: PatientDetailView(appointmentData: appointmentData, submitAction: {
                        switchToDoctorsView()
                        dismiss()
                    })) {
                        Text("Book Appointment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customRed)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color.customPalePink.ignoresSafeArea())
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Doctor Profile")
        }
    }
}

// Communication Option View
struct CommunicationOptionView: View {
    var imageName: String
    var title: String
    var description: String

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .font(.title2)
                .foregroundColor(.customDarkBlue)
                .padding(10)
                .background(Circle().fill(Color.customLightBlue))

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.customNavy)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 4)
    }
}

// Preview with sample data
//struct NewDoctorProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        NewDoctorProfileView(newDoctor: NewDoctor(
//            imageName: "doctorImage",  // Replace with an actual image name
//            name: "Dr. Bellamy Nicholas",
//            rating: 4.5,
//            reviews: 135,
//            specialty: "Virologist",
//            aboutDoctor: "Dr. Bellamy Nicholas is a top specialist at London Bridge Hospital. He has achieved several awards and recognition for his contributions and service in the field of virology."
//        ))
//    }
//}

// PatientDetailView as a placeholder
