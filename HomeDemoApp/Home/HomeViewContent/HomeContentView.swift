//
//  HomeContentView.swift
//  Home
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import Core

public struct HomeContentView: View {
    
    @StateObject var vm = HomeViewModel()
    
    let sampleDoctors = [
        Doctor(id: "1", name: "Dr. John Doe", specialty: "Cardiology", wing: "A", ward: "4A", bed: "43", imageName: "doctor1"),
        Doctor(id: "2", name: "Dr. Jane Smith", specialty: "Neurology", wing: "B", ward: "5B", bed: "12", imageName: "doctor1"),
        Doctor(id: "1", name: "Dr. John Doe", specialty: "Cardiology", wing: "A", ward: "4A", bed: "43", imageName: "doctor1"),
        Doctor(id: "2", name: "Dr. Jane Smith", specialty: "Neurology", wing: "B", ward: "5B", bed: "12", imageName: "doctor1"),
        Doctor(id: "1", name: "Dr. John Doe", specialty: "Cardiology", wing: "A", ward: "4A", bed: "43", imageName: "doctor1"),
        Doctor(id: "2", name: "Dr. Jane Smith", specialty: "Neurology", wing: "B", ward: "5B", bed: "12", imageName: "doctor1"),
        Doctor(id: "1", name: "Dr. John Doe", specialty: "Cardiology", wing: "A", ward: "4A", bed: "43", imageName: "doctor1"),
        Doctor(id: "2", name: "Dr. Jane Smith", specialty: "Neurology", wing: "B", ward: "5B", bed: "12", imageName: "doctor1"),
        Doctor(id: "1", name: "Dr. John Doe", specialty: "Cardiology", wing: "A", ward: "4A", bed: "43", imageName: "doctor1"),
        Doctor(id: "2", name: "Dr. Jane Smith", specialty: "Neurology", wing: "B", ward: "5B", bed: "12", imageName: "doctor1"),
    ]
    
    let sampleMedicalItems = [
        MedicalItem(id: "1", title: "ECG Machine", description: "Electrocardiography machine for heart monitoring.", icon: "waveform.path.ecg"),
        MedicalItem(id: "2", title: "Blood Pressure Monitor", description: "Device to measure blood pressure levels.", icon: "gauge"),
        MedicalItem(id: "3", title: "MRI Scanner", description: "Magnetic Resonance Imaging machine.", icon: "circle.fill"),
        MedicalItem(id: "4", title: "Oxygen Tank", description: "Tank used for oxygen therapy.", icon: "lungs.fill"),
        MedicalItem(id: "5", title: "Syringe Kit", description: "Kit for injecting medications.", icon: "cross.case.fill")
    ]
    
    public init() {  }
    
    public var body: some View {
        contentView()
    }
}

extension HomeContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.customLightBlue, Color.customPalePink]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16.dpHeight()) {
                    doctorsSection()
                    
                    medicalSection()
                }
                .padding(.top, (UIScreen.main.bounds.height / 2.8).dpHeight())
            }
            VStack {
                VStack(spacing: 8.dpHeight()) {
                    Text("Hi, \(UserDefaults.standard.string(forKey: "userFullName") ?? "") 👋🏼")
                        .foregroundColor(.customPalePink)
                        .font(.sabFont(700, size: 30))
                    
                    HStack(spacing: 8.dpWidth()) {
                        healthDataView(
                            value: vm.formattedValue(vm.heartRate),
                            label: "Heart Rate",
                            color: .customRed,
                            icon: "heart.fill"
                        )
                        healthDataView(
                            value: vm.formattedValue(vm.spO2),
                            label: "SpO2",
                            color: .customRed,
                            icon: "drop.fill"
                        )
                        healthDataView(
                            value: vm.formattedValue(vm.activeEnergyBurned),
                            label: "Calories",
                            color: .customRed,
                            icon: "flame.fill"
                        )
                    }
                    HStack(spacing: 8.dpWidth()) {
                        healthDataView(
                            value: vm.formattedValue(vm.steps),
                            label: "Steps",
                            color: .customNavy,
                            icon: "figure.walk"
                        )
                        healthDataView(
                            value: vm.formattedValue(vm.respiratoryRate),
                            label: "Respiration",
                            color: .customNavy,
                            icon: "lungs.fill"
                        )
                        healthDataView(
                            value: vm.formattedValue(vm.bodyTemperature),
                            label: "Temperature",
                            color: .customNavy,
                            icon: "thermometer"
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16.dpHeight())
                .padding(.top, 70.dpHeight())
                .background(Color.customDarkBlue)
                .cornerRadius(35.dpHeight())
                .ignoresSafeArea()
                
                Spacer()
            }
        }
    }

}

extension HomeContentView {
    
    func healthDataView(value: String, label: String, color: Color, icon: String) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundColor(.white)
                .padding(10)
                .background(Color.black.opacity(0.1))
                .clipShape(Circle())
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 110.dpWidth(), height: 110.dpHeight())
        .background(color)
        .cornerRadius(24.dpHeight())
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

struct DoctorCardView: View {
    let name: String
    let id: String
    let specialty: String
    let wing: String
    let ward: String
    let bed: String
    let imageName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.customNavy)
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.customLightBlue)
            }
            
            Text("ID: \(id)")
                .font(.subheadline)
                .foregroundColor(.customDarkBlue.opacity(0.8))
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Wing: \(wing)")
                    Text("Ward: \(ward)")
                    Text("Bed: \(bed)")
                }
                .font(.caption)
                .foregroundColor(.customNavy.opacity(0.8))
                
                Spacer()
                
                Text("⚕️")
                    .font(.sabFont(700, size: 55))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.customLightBlue, lineWidth: 1)
                    )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.customPalePink, Color.customLightBlue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: Color.customNavy.opacity(0.2), radius: 8, x: 0, y: 4)
        )
        .padding(.vertical, 8.dpHeight())
    }
}

struct DoctorScrollView: View {
    let doctors: [Doctor]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16.dpWidth()) {
                ForEach(doctors, id: \.id) { doctor in
                    DoctorCardView(
                        name: doctor.name,
                        id: doctor.id,
                        specialty: doctor.specialty,
                        wing: doctor.wing,
                        ward: doctor.ward,
                        bed: doctor.bed,
                        imageName: doctor.imageName
                    )
                    .frame(width: 300)
                }
            }
            .padding(.horizontal, 16.dpWidth())
        }
    }
}

struct Doctor: Identifiable {
    let id: String
    let name: String
    let specialty: String
    let wing: String
    let ward: String
    let bed: String
    let imageName: String
}

struct MedicalCardView: View {
    let title: String
    let description: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.customNavy)
                Spacer()
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(.customLightBlue)
            }
            
            Text(description)
                .font(.subheadline)
                .foregroundColor(.customDarkBlue.opacity(0.8))
                .lineLimit(3)
            
            Spacer()
        }
        .padding()
        .frame(width: 250, height: 150)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.customLightBlue, Color.customPalePink]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: Color.customNavy.opacity(0.2), radius: 8, x: 0, y: 4)
        .padding(.vertical, 8.dpHeight())
    }
}

struct MedicalScrollView: View {
    let medicalItems: [MedicalItem]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16.dpWidth()) {
                ForEach(medicalItems, id: \.id) { item in
                    MedicalCardView(
                        title: item.title,
                        description: item.description,
                        icon: item.icon
                    )
                    .frame(width: 250)
                }
            }
            .padding(.horizontal, 16.dpWidth())
        }
    }
}

struct MedicalItem: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
}

extension HomeContentView {
    
    func doctorsSection() -> some View {
        VStack(alignment: .leading, spacing: 16.dpHeight()) {
            Text("DOCTORS")
                .font(.sabFont(700, size: 19))
                .foregroundColor(.customDarkBlue)
                .padding(.horizontal, 16.dpWidth())
            
            DoctorScrollView(doctors: sampleDoctors)
        }
    }
    
    func medicalSection() -> some View {
        VStack(alignment: .leading, spacing: 16.dpHeight()) {
            Text("MEDICAL")
                .font(.sabFont(700, size: 19))
                .foregroundColor(.customDarkBlue)
                .padding(.horizontal, 16.dpWidth())
            
            MedicalScrollView(medicalItems: sampleMedicalItems)
        }
    }
}
