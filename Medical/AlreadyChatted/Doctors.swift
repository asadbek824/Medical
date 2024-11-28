//
//  Doctors.swift
//  Chat_Doc
//
//  Created by islombek on 14/11/24.
//

import SwiftUI
import Core

// Doctor Model
struct Doctor: Identifiable {
    let id = UUID()
    let name: String
    let specialty: String
    let rating: Double
    let reviews: Int
    let imageName: String
    let isOnline: Bool
    let aboutDoctor: String
}

// Doctors View
struct DoctorsView: View {
    // Sample data
    @State private var doctors: [Doctor] = []
    
    @ObservedObject var appointmentData: AppointmentData
    @Binding var selectedDoctor: Doctor?
    
    @State private var filteredDoctors: [Doctor] = []
    @State private var selectedFilterOption: String? = nil
    
    init(doctors: [Doctor], appointmentData: AppointmentData, selectedDoctor: Binding<Doctor?>) {
        self.doctors = doctors
        self.appointmentData = appointmentData
        self._selectedDoctor = selectedDoctor
        _filteredDoctors = State(initialValue: [])
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Title and Filter Menu
                HStack {
                    Text("Doctors")
                        .font(.title2)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .foregroundColor(Color.customDarkBlue)
                    Spacer()
                    Menu {
                        Button("Filter by Name") {
                            selectedFilterOption = "Name"
                            applyFilter()
                        }
                        Button("Filter by Rating") {
                            selectedFilterOption = "Rating"
                            applyFilter()
                        }
                        Button("Filter by No Reviews") {
                            selectedFilterOption = "No Reviews"
                            applyFilter()
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .font(.title2)
                            .foregroundColor(.customNavy)
                    }
                }
                .padding(.horizontal)
                
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for doctors", text: .constant(""))
                        .padding(8)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Doctors grid
                ScrollView {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2), spacing: 16) {
                        ForEach(filteredDoctors.isEmpty ? doctors : filteredDoctors) { doctor in
                            DoctorCardView(doctor: doctor)
                                .onTapGesture {
                                    selectedDoctor = doctor
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                            get: { selectedDoctor != nil },
                            set: { if !$0 { selectedDoctor = nil } }
            )) {
                ChatWithDoctorsView(
                    doctor: selectedDoctor ?? Doctor(
                        name: "Dr. O’Boyle J",
                        specialty: "Radiologist",
                        rating: 4.5,
                        reviews: 135,
                        imageName: "doctor1",
                        isOnline: true,
                        aboutDoctor: ""
                    ),
                    initialMessages: [], appointmentData: appointmentData
                )
            }
            .onAppear {
                print("\(appointmentData.fullName), \(appointmentData.problemDescription), \(appointmentData.selectedGender), \(appointmentData.selectedAgeGroup)")
            }
            .navigationBarHidden(true)
            .background(
                LinearGradient(
                    gradient:
                        Gradient(colors: [Color.customLightBlue, Color(hex: "#F1FAEE")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .onAppear {
                filteredDoctors = doctors
            }
        }
    }
    
    private func applyFilter() {
        guard let filter = selectedFilterOption else { return }
        
        switch filter {
        case "Name":
            filteredDoctors = doctors.sorted { $0.name < $1.name }
        case "Rating":
            filteredDoctors = doctors.filter { $0.rating >= 4.5 }
        case "No Reviews":
            filteredDoctors = doctors.filter { $0.reviews == 0 }
        default:
            filteredDoctors = doctors
        }
    }
}

// Doctor Card View
struct DoctorCardView: View {
    let doctor: Doctor
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .topTrailing) {
                Image(doctor.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                if doctor.isOnline {
                    Circle()
                        .fill(Color.customLightBlue)
                        .frame(width: 12, height: 12)
                        .offset(x: -5, y: 5)
                }
            }
            
            Text(doctor.name)
                .font(.headline)
                .foregroundColor(.customDarkBlue)
            
            Text(doctor.specialty)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.customRed)
                    .font(.caption)
                
                Text(String(format: "%.1f", doctor.rating))
                    .font(.subheadline)
                    .foregroundColor(.customNavy)
                
                Text("(\(doctor.reviews) reviews)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .clipShape(RoundedCornerShape(radius: 40, corners: [.topLeft, .bottomRight])) // Custom rounded corners
        .shadow(color: Color.customLightBlue.opacity(0.4), radius: 5, x: 0, y: 5)
    }
}



struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}




