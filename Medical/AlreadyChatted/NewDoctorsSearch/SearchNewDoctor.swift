//
//  SearchNewDoctor.swift
//  Chat_Doc
//
//  Created by islombek on 15/11/24.
//

import SwiftUI
import Core

struct MainDoctorsListView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String? = nil
    @State private var nextViewPresented: Bool = false
    @State var newdoctor: NewDoctor
  //  @State var doctor: Doctor
    
    @ObservedObject var appointmentData: AppointmentData
    var switchToDoctorsView: () -> Void
    

    // Updated doctor information
    let doctorsBySpecialty: [String: [NewDoctor]] = [
        "Cardiology": [
            NewDoctor(imageName: "doctor1", name: "Dr. Bellamy Nicholas", rating: 4.8, reviews: 145, specialty: "Cardiology", aboutDoctor: "Specialist in heart diseases with over 20 years of experience."),
            NewDoctor(imageName: "doctor1", name: "Dr. Emily Stone", rating: 4.7, reviews: 120, specialty: "Cardiology", aboutDoctor: "Expert in cardiovascular health and rehabilitation."),
            NewDoctor(imageName: "doctor1", name: "Dr. Alex White", rating: 4.6, reviews: 100, specialty: "Cardiology", aboutDoctor: "Focuses on preventive heart care."),
            NewDoctor(imageName: "doctor1", name: "Dr. Julia Miller", rating: 4.9, reviews: 150, specialty: "Cardiology", aboutDoctor: "Expert in arrhythmia and heart rhythm disorders."),
            NewDoctor(imageName: "doctor1", name: "Dr. Michael Scott", rating: 4.7, reviews: 130, specialty: "Cardiology", aboutDoctor: "Experienced in coronary artery disease treatment."),
            NewDoctor(imageName: "doctor1", name: "Dr. Olivia Green", rating: 4.8, reviews: 170, specialty: "Cardiology", aboutDoctor: "Specializes in heart failure management."),
            NewDoctor(imageName: "doctor1", name: "Dr. Samuel Brooks", rating: 4.5, reviews: 90, specialty: "Cardiology", aboutDoctor: "Focuses on hypertensive heart disease.")
        ],
        
        "Pediatrics": [
            NewDoctor(imageName: "doctor1", name: "Dr. Sarah Lin", rating: 4.9, reviews: 180, specialty: "Pediatrics", aboutDoctor: "Over a decade of experience in child healthcare."),
            NewDoctor(imageName: "doctor1", name: "Dr. Paul Rivers", rating: 4.8, reviews: 160, specialty: "Pediatrics", aboutDoctor: "Focuses on child nutrition and wellness."),
            NewDoctor(imageName: "doctor1", name: "Dr. Olivia Brown", rating: 4.7, reviews: 140, specialty: "Pediatrics", aboutDoctor: "Specializes in early development and immunizations."),
            NewDoctor(imageName: "doctor1", name: "Dr. Elizabeth Gray", rating: 4.6, reviews: 100, specialty: "Pediatrics", aboutDoctor: "Expert in pediatric respiratory care."),
            NewDoctor(imageName: "doctor1", name: "Dr. Luke Stevens", rating: 4.7, reviews: 110, specialty: "Pediatrics", aboutDoctor: "Specializes in childhood immunizations and infectious diseases."),
            NewDoctor(imageName: "doctor1", name: "Dr. Sophia James", rating: 4.9, reviews: 180, specialty: "Pediatrics", aboutDoctor: "Focuses on pediatric neurology and brain development."),
            NewDoctor(imageName: "doctor1", name: "Dr. Daniel Thomas", rating: 4.8, reviews: 150, specialty: "Pediatrics", aboutDoctor: "Experienced in pediatric allergies and asthma treatment.")
        ],
        
        "Dermatology": [
            NewDoctor(imageName: "doctor1", name: "Dr. Laura King", rating: 4.9, reviews: 190, specialty: "Dermatology", aboutDoctor: "Specializes in skin cancer detection and treatment."),
            NewDoctor(imageName: "doctor1", name: "Dr. Kenneth Lee", rating: 4.8, reviews: 180, specialty: "Dermatology", aboutDoctor: "Expert in acne, eczema, and psoriasis management."),
            NewDoctor(imageName: "doctor1", name: "Dr. Megan Lopez", rating: 4.7, reviews: 160, specialty: "Dermatology", aboutDoctor: "Skilled in cosmetic dermatology and anti-aging treatments."),
            NewDoctor(imageName: "doctor1", name: "Dr. John Davis", rating: 4.6, reviews: 140, specialty: "Dermatology", aboutDoctor: "Focused on pediatric dermatology and skin disorders in children."),
            NewDoctor(imageName: "doctor1", name: "Dr. Grace White", rating: 4.8, reviews: 170, specialty: "Dermatology", aboutDoctor: "Expert in laser skin treatments and surgical dermatology."),
            NewDoctor(imageName: "doctor1", name: "Dr. Elizabeth Thompson", rating: 4.9, reviews: 200, specialty: "Dermatology", aboutDoctor: "Leads research in immunodermatology and autoimmune skin diseases."),
            NewDoctor(imageName: "doctor1", name: "Dr. Daniel Clark", rating: 4.7, reviews: 150, specialty: "Dermatology", aboutDoctor: "Specializes in fungal and viral skin infections.")
        ],

        "Orthopedics": [
            NewDoctor(imageName: "doctor1", name: "Dr. Rachel Adams", rating: 4.8, reviews: 140, specialty: "Orthopedics", aboutDoctor: "Specializes in joint replacements and sports injuries."),
            NewDoctor(imageName: "doctor1", name: "Dr. James Wilson", rating: 4.7, reviews: 130, specialty: "Orthopedics", aboutDoctor: "Experienced in spine surgery and rehabilitation."),
            NewDoctor(imageName: "doctor1", name: "Dr. Nathan Roberts", rating: 4.9, reviews: 160, specialty: "Orthopedics", aboutDoctor: "Focuses on shoulder and knee reconstruction."),
            NewDoctor(imageName: "doctor1", name: "Dr. Olivia Martinez", rating: 4.6, reviews: 120, specialty: "Orthopedics", aboutDoctor: "Expert in pediatric orthopedics and bone development."),
            NewDoctor(imageName: "doctor1", name: "Dr. Daniel Evans", rating: 4.7, reviews: 150, specialty: "Orthopedics", aboutDoctor: "Skilled in minimally invasive orthopedic surgeries."),
            NewDoctor(imageName: "doctor1", name: "Dr. Henry White", rating: 4.8, reviews: 170, specialty: "Orthopedics", aboutDoctor: "Specializes in sports-related injuries and rehabilitation.")
        ],

        "Oncology": [
            NewDoctor(imageName: "doctor1", name: "Dr. Isabella King", rating: 4.9, reviews: 180, specialty: "Oncology", aboutDoctor: "Expert in breast cancer treatment and prevention."),
            NewDoctor(imageName: "doctor1", name: "Dr. William Clark", rating: 4.8, reviews: 160, specialty: "Oncology", aboutDoctor: "Specializes in hematology and blood cancers."),
            NewDoctor(imageName: "doctor1", name: "Dr. Charlotte Walker", rating: 4.7, reviews: 140, specialty: "Oncology", aboutDoctor: "Focuses on immunotherapy and targeted cancer treatments."),
            NewDoctor(imageName: "doctor1", name: "Dr. David Smith", rating: 4.9, reviews: 200, specialty: "Oncology", aboutDoctor: "Experienced in palliative care and managing cancer pain."),
            NewDoctor(imageName: "doctor1", name: "Dr. Emily Wright", rating: 4.8, reviews: 170, specialty: "Oncology", aboutDoctor: "Expert in lung cancer research and treatment."),
            NewDoctor(imageName: "doctor1", name: "Dr. Daniel Thompson", rating: 4.6, reviews: 130, specialty: "Oncology", aboutDoctor: "Specializes in colon and gastrointestinal cancers.")
        ],
        
        "Neurology": [
            NewDoctor(imageName: "doctor1", name: "Dr. Caroline Harris", rating: 4.8, reviews: 180, specialty: "Neurology", aboutDoctor: "Focuses on Alzheimer's disease and neurodegenerative disorders."),
            NewDoctor(imageName: "doctor1", name: "Dr. Samuel Jones", rating: 4.7, reviews: 160, specialty: "Neurology", aboutDoctor: "Expert in epilepsy and seizure management."),
            NewDoctor(imageName: "doctor1", name: "Dr. Megan Green", rating: 4.9, reviews: 190, specialty: "Neurology", aboutDoctor: "Specializes in movement disorders like Parkinson's disease."),
            NewDoctor(imageName: "doctor1", name: "Dr. Luke Carter", rating: 4.6, reviews: 140, specialty: "Neurology", aboutDoctor: "Experienced in stroke recovery and rehabilitation."),
            NewDoctor(imageName: "doctor1", name: "Dr. Rachel White", rating: 4.8, reviews: 170, specialty: "Neurology", aboutDoctor: "Expert in neurogenetics and genetic counseling."),
            NewDoctor(imageName: "doctor1", name: "Dr. Thomas Brooks", rating: 4.7, reviews: 150, specialty: "Neurology", aboutDoctor: "Specializes in traumatic brain injuries and rehabilitation.")
        ]
    ]

    
    var filteredDoctorsBySpecialty: [String: [NewDoctor]] {
        // Шаг 1: Фильтрация докторов по тексту поиска
        let filteredDoctors = doctorsBySpecialty.mapValues { doctors in
            doctors.filter { doctor in
                searchText.isEmpty ||
                doctor.name.lowercased().contains(searchText.lowercased()) ||
                doctor.specialty.lowercased().contains(searchText.lowercased())
            }
        }
        
        // Шаг 2: Фильтрация по выбранной категории
        if let selectedCategory = selectedCategory {
            return filteredDoctors.filter { key, _ in key == selectedCategory }
        } else {
            return filteredDoctors
        }
    }

    var body: some View {
        NavigationView {
           
                
            ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(spacing: 0) {
                        // Search Bar with modern design
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            TextField("Search doctors by name or specialty...", text: $searchText)
                                .padding(14)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        .padding(.top, 16)
                        
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(filteredDoctorsBySpecialty.keys.sorted(), id: \.self) { specialty in
                            VStack(alignment: .leading, spacing: 16) {
                                Text(specialty)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                    .padding(.horizontal)

                                ForEach(filteredDoctorsBySpecialty[specialty] ?? []) { doctor in
                                    NewDoctorCardView(doctor: doctor)
                                        .padding(.horizontal)
                                        .transition(.slide)
                                        .animation(.easeInOut(duration: 0.3))
                                        .onTapGesture {
                                            nextViewPresented = true
                                        }
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .background(
                LinearGradient(
                    gradient:
                        Gradient(colors: [Color.customLightBlue, Color(hex: "#F1FAEE")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .navigationTitle("Doctors")
            .navigationBarItems(trailing: Menu {
                Button("All Categories") {
                    selectedCategory = nil
                }

                ForEach(doctorsBySpecialty.keys.sorted(), id: \.self) { category in
                    Button(category) {
                        selectedCategory = category
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            })
            .sheet(isPresented: $nextViewPresented) {
                NewDoctorProfileView(newDoctor: newdoctor, appointmentData: appointmentData, switchToDoctorsView: switchToDoctorsView)
            }
        }
    }
}

// Doctor Model
struct NewDoctor: Identifiable {
    let id = UUID()
    let imageName: String
    let name: String
    let rating: Double
    let reviews: Int
    let specialty: String
    let aboutDoctor: String
}

// Doctor Card View with modern design
struct NewDoctorCardView: View {
    let doctor: NewDoctor

    var body: some View {
        HStack(spacing: 16) {
            Image(doctor.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(radius: 5)
                .padding(.leading, -50)
Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                Text(doctor.name)
                    .font(.headline)
                    .foregroundColor(.primary)
             
                Text(doctor.specialty)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
      
                HStack(spacing: 4) {
                    Text("\(doctor.rating, specifier: "%.1f")")
                        .font(.subheadline.bold())
                        .foregroundColor(.yellow)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("(\(doctor.reviews) reviews)")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }.padding(.leading, -20)
            Spacer()
        }
        .padding(.horizontal, 30)
       
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        ).padding(.horizontal, 25)
        
        .padding(.vertical, 8)
        .transition(.scale)
    }
}

// Preview
//struct MainDoctorsListView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainDoctorsListView(doctor: $doctor)
//    }
//}

