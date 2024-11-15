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
    
    public init() {  }
    
    public var body: some View {
        contentView()
    }
}

extension HomeContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24.dpHeight()) {
                    HStack(spacing: 16.dpWidth()) {
                        healthDataView(value: vm.formattedValue(vm.heartRate), label: "Heart Rate", color: .customNavy, icon: "heart.fill")
                        healthDataView(value: vm.formattedValue(vm.spO2), label: "SpO2", color: .customRed, icon: "drop.fill")
                        healthDataView(value: vm.formattedValue(vm.bodyTemperature), label: "Temperature", color: .customNavy, icon: "thermometer")
                    }
                    HStack(spacing: 16.dpWidth()) {
                        healthDataView(value: vm.formattedValue(vm.steps), label: "Steps", color: .customDarkBlue, icon: "figure.walk")
                        healthDataView(value: vm.formattedValue(vm.respiratoryRate), label: "Respiration", color: .customPalePink, icon: "lungs.fill")
                        healthDataView(value: vm.formattedValue(vm.activeEnergyBurned), label: "Calories", color: .customRed, icon: "flame.fill")
                    }
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .navigationTitle("Health Overview")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.customPalePink.edgesIgnoringSafeArea(.all))
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
        .cornerRadius(16.dpHeight())
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}
