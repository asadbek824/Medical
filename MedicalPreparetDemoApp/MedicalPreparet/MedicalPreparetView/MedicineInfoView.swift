//
//  MedicineInfoView.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/16/24.
//

import SwiftUI
import Core

struct MedicineInfoView: View {
    @EnvironmentObject var vm: MedicalPreparetViewModel
    let medicineInfo: MedicineInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Medicine Name
                Text(medicineInfo.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.customDarkBlue)

                // Description
                Text("Description")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                Text(medicineInfo.description)
                    .font(.body)

                // Application
                Text("Application")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                Text(medicineInfo.application)
                    .font(.body)

                // Restrictions
                Text("Restrictions")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                Text(medicineInfo.restrictions)
                    .font(.body)

                // Manufacturer
                Text("Manufacturer")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                Text(medicineInfo.manufacturer)
                    .font(.body)

                // Country of Origin
                Text("Country of Origin")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                Text(medicineInfo.countryOfOrigin)
                    .font(.body)

                // Active Ingredients
                Text("Active Ingredients")
                    .font(.headline)
                    .foregroundColor(Color.customDarkBlue)
                ForEach(medicineInfo.activeIngredients, id: \.name) { ingredient in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(ingredient.name) (\(ingredient.concentration))")
                            .font(.body)
                            .fontWeight(.semibold)
                        Text(ingredient.purpose)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                if vm.isLoading {
                    HStack {
                        Text("Search Analogs this Medical")
                            .font(.sabFont(700, size: 19))
                            .foregroundColor(Color.customDarkBlue)
                        ProgressView()
                    }
                } else {
                    if let analogs = vm.analogProducts?.analogs {
                        let uzbekistanAnalogs = analogs.filter { $0.country == "Узбекистан" }
                        let otherAnalogs = analogs.filter { $0.country != "Узбекистан" }
                        
                        if !uzbekistanAnalogs.isEmpty {
                            Text("Made in Uzbekistan")
                                .font(.sabFont(700, size: 19))
                                .foregroundColor(Color.customDarkBlue)
                            ForEach(uzbekistanAnalogs, id: \.name) { analog in
                                AnalogView(analog: analog)
                            }
                        }

                        if !otherAnalogs.isEmpty {
                            Text("Not Made in Uzbekistan")
                                .font(.sabFont(700, size: 19))
                                .foregroundColor(Color.customDarkBlue)
                            ForEach(otherAnalogs, id: \.name) { analog in
                                AnalogView(analog: analog)
                            }
                        }
                    }
                }
            }
            .padding(16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.customPalePink, Color.customLightBlue]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct AnalogView: View {
    let analog: Analog

    var body: some View {
        VStack(alignment: .leading) {
            Text(analog.name)
                .font(.headline)
                .foregroundColor(Color.customDarkBlue)
            Text("Company: \(analog.company)")
                .font(.subheadline)
                .foregroundColor(Color.gray)
        }
        .padding()
    }
}


