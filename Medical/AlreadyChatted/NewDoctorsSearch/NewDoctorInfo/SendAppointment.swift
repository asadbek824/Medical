//
//  SendAppointment.swift
//  Chat_Doc
//
//  Created by islombek on 16/11/24.
//

import SwiftUI

struct PatientDetailView: View {
    @Environment(\.dismiss) private var dismiss // For dismissing the view
    @State private var fullName: String = ""
    @State private var selectedAgeGroup: String = "1-5"
    @State private var selectedGender: String = "Male"
    @State private var problemDescription: String = ""
    
    let ageGroups = ["1-5", "5-10", "10-17", "17-25", "25-35", "35+"]
    let genders = ["Male", "Female"]
    
    @ObservedObject var appointmentData: AppointmentData
    var submitAction: () -> Void

    var body: some View {
        ZStack {
            Color.customPalePink.ignoresSafeArea() // Background color
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Patient Details")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.customNavy)
                        
                        Text("Fill in the information below to book an appointment.")
                            .font(.body)
                            .foregroundColor(.customDarkBlue)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                    }
                    .padding(.top, 20)
                    
                    // Full Name Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.headline)
                            .foregroundColor(.customNavy)
                        
                        TextField("Enter full name", text: $appointmentData.fullName)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    
                    // Age Group Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Age Group")
                            .font(.headline)
                            .foregroundColor(.customNavy)
                        
                        Picker("Age Group", selection: $appointmentData.selectedAgeGroup) {
                            ForEach(ageGroups, id: \.self) { age in
                                Text(age)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    
                    // Gender Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Gender")
                            .font(.headline)
                            .foregroundColor(.customNavy)
                        
                        Picker("Gender", selection: $appointmentData.selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    
                    // Problem Description Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Problem Description")
                            .font(.headline)
                            .foregroundColor(.customNavy)
                        
                        TextField("Describe the problem", text: $appointmentData.problemDescription)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    
                    // Send Appointment Button
                    Button(action: {
                        submitAction()
                        dismiss() // Dismiss the view after submitting
                    }) {
                        Text("Send Appointment")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.customRed)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 4)
                    }
                    .padding(.horizontal, 16)
                    
                    Spacer()
                }
                .padding(.vertical)
            }
        }
    }
}
