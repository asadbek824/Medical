//
//  ConsultationView.swift
//  Chat_Doc
//
//  Created by islombek on 16/11/24.
//

import SwiftUI

struct ConsultationView: View {
    @State private var selectedDate: Date = Date()
    @State private var selectedDuration: String = "30 min"
    @State private var selectedForWhom: String = "Self"
    @State private var selectedSlot: String = ""  // Change to single string
    @State private var showConfirmation = false

    // Dummy slot data
    let availableSlots = [
        "10:00 AM - 10:30 AM", "10:30 AM - 11:00 AM", "11:00 AM - 11:30 AM",
        "02:00 PM - 02:30 PM", "02:30 PM - 03:00 PM", "03:00 PM - 03:30 PM"
    ]
    
    let durations = ["30 min", "60 min", "90 min"]
    let forWhomOptions = ["Self", "Family Member", "Friend"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.customLightBlue, Color.customPalePink]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack {
                Text("Consultation Slot")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.customNavy)
                    .padding(.top, 40)
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer()

                VStack(spacing: 30) {
                    CustomDatePicker(selectedDate: $selectedDate)

                    // Change selectedTimes to selectedSlot for single selection
                    CustomPicker(title: "Available Slots:", selection: $selectedSlot, options: availableSlots, width: 250)

                    CustomPicker(title: "Duration:", selection: $selectedDuration, options: durations, width: 200)

                    CustomPicker(title: "For Whom:", selection: $selectedForWhom, options: forWhomOptions, width: 200)
                }
                .padding(.horizontal, 25)

                Button(action: {
                    saveSlotData()
                    showConfirmation.toggle()
                }) {
                    Text("Confirm Consultation")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.customNavy))
                        .foregroundColor(.white)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 40)

            }
            .padding(.top, 20)
            .fullScreenCover(isPresented: $showConfirmation) {
                ConfirmationView(selectedDate: selectedDate, selectedSlot: selectedSlot, selectedDuration: selectedDuration, selectedForWhom: selectedForWhom)
            }
        }
    }

    // Custom Picker View
    private func CustomPicker(title: String, selection: Binding<String>, options: [String], width: CGFloat) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            Picker("Select", selection: selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: width)
            .foregroundColor(Color.customNavy)
            .padding(10)
            //.background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
        }
    }

    private func CustomDatePicker(selectedDate: Binding<Date>) -> some View {
        HStack {
            Text("Select Date & Time:")
                .font(.headline)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)

            DatePicker("", selection: selectedDate, displayedComponents: .date)
                .datePickerStyle(WheelDatePickerStyle())
                .frame(width: 200)
                .padding(10)
              //  .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
                .foregroundColor(.customDarkBlue)
        }
    }

    private func saveSlotData() {
        // Save the selected slot data here
        print("Saved Slot:")
        print("Date: \(selectedDate)")
        print("Time Slot: \(selectedSlot)")  // Now it's a single string, not an array
        print("Duration: \(selectedDuration)")
        print("For Whom: \(selectedForWhom)")
    }
}




struct MultipleSelectionView: View {
    @State private var selectedSlots: Set<String> = []  // Track multiple selections

    let availableSlots = [
        "10:00 AM - 10:30 AM", "10:30 AM - 11:00 AM", "11:00 AM - 11:30 AM",
        "02:00 PM - 02:30 PM", "02:30 PM - 03:00 PM", "03:00 PM - 03:30 PM"
    ]

    var body: some View {
        List(availableSlots, id: \.self) { slot in
            HStack {
                Text(slot)
                    .font(.body)
                Spacer()
                Image(systemName: self.selectedSlots.contains(slot) ? "checkmark.circle.fill" : "circle")
                    .onTapGesture {
                        if self.selectedSlots.contains(slot) {
                            self.selectedSlots.remove(slot)
                        } else {
                            self.selectedSlots.insert(slot)
                        }
                    }
            }
            .padding()
        }
    }
}


struct ConfirmationView: View {
    var selectedDate: Date
    var selectedSlot: String
    var selectedDuration: String
    var selectedForWhom: String

    var body: some View {
        VStack {
            Text("Consultation Confirmed")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.customDarkBlue)
                .padding(.top)

            Text("Date: \(formattedDate(date: selectedDate))")
                .font(.body)
                .foregroundColor(.primary)

            Text("Time Slot: \(selectedSlot)")
                .font(.body)
                .foregroundColor(.primary)

            Text("Duration: \(selectedDuration)")
                .font(.body)
                .foregroundColor(.primary)

            Text("For Whom: \(selectedForWhom)")
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Button(action: {
                // Action for confirmation button
            }) {
                Text("Confirm")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.customDarkBlue))
                    .foregroundColor(.white)
                    .padding(.top)
            }
            .padding(.horizontal, 25)
        }
        .background(Color.customPalePink.ignoresSafeArea())
    }

    private func formattedDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
}
