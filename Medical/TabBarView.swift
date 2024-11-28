//
//  TabBarView.swift
//  Medical
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Home
import Core
import AIChat
import DoctorChat
import MedicalPreparet

class AppointmentData: ObservableObject {
    @Published var fullName: String = ""
    @Published var selectedAgeGroup: String = ""
    @Published var selectedGender: String = ""
    @Published var problemDescription: String = ""
}

struct TabBarView: View {
    
    @State private var doctors = [
        Doctor(name: "Dr. Bellamy N", specialty: "Virologist", rating: 4.5, reviews: 135, imageName: "doctor1", isOnline: true, aboutDoctor: ""),
        Doctor(name: "Dr. Mensah T", specialty: "Oncologist", rating: 4.3, reviews: 130, imageName: "doctor1", isOnline: true, aboutDoctor: ""),
        Doctor(name: "Dr. Klimisch J", specialty: "Surgeon", rating: 4.5, reviews: 135, imageName: "doctor1", isOnline: false, aboutDoctor: ""),
        Doctor(name: "Dr. Martinez K", specialty: "Pediatrician", rating: 4.3, reviews: 130, imageName: "doctor1", isOnline: true, aboutDoctor: ""),
        Doctor(name: "Dr. Marc M", specialty: "Rheumatologist", rating: 4.3, reviews: 130, imageName: "doctor1", isOnline: false, aboutDoctor: ""),
        Doctor(name: "Dr. O’Boyle J", specialty: "Radiologist", rating: 4.5, reviews: 135, imageName: "doctor1", isOnline: true, aboutDoctor: "")
    ]
    
    @State private var selectedTab: Tab = .home
    @State var newDoctor: NewDoctor
    @StateObject private var appointmentData = AppointmentData()
    @State private var selectedDoctor: Doctor?
    
    enum Tab {
        case home
        case aichat
        case prescription
        case doctorsView
        case mainDoctors
    }
    
    var body: some View {
        contentView()
    }
}

extension TabBarView {
    
    @ViewBuilder
    func contentView() -> some View {
        TabView(selection: $selectedTab) {
            HomeContentView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)
            
            AIChatContentView()
                .tabItem {
                    Label("AI Chat", systemImage: "message.fill")
                }
                .tag(Tab.aichat)
            
            MedicalPreparetContentView()
                .tabItem {
                    Label("AI Prescription", systemImage: "pills")
                }
                .tag(Tab.prescription)
            
            DoctorsView(doctors: doctors, appointmentData: appointmentData,  selectedDoctor: $selectedDoctor)
                .tabItem {
                    Label("Doctors Chat", systemImage: "stethoscope")
                }
                .tag(Tab.doctorsView)
            
            MainDoctorsListView(newdoctor: newDoctor, appointmentData: appointmentData, switchToDoctorsView: {
                selectedTab = Tab.doctorsView
                
                selectedDoctor = doctors.first
            })
                .tabItem {
                    Label("Doctors List", systemImage: "circle")
                }
                .tag(Tab.mainDoctors)
        }
        .accentColor(Color.customDarkBlue)
        .background(Color.customPalePink.edgesIgnoringSafeArea(.all))
    }
}
