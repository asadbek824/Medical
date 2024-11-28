//
//  MedicalPreparetContentView.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import SwiftUI
import Core

public struct MedicalPreparetContentView: View {
    
    @StateObject var vm = MedicalPreparetViewModel()
    
    public init() {  }
    
    public var body: some View {
        NavigationStack {
            contentView()
                .navigationDestination(
                    isPresented: Binding(
                        get: { vm.selectedMedicineInfo != nil },
                        set: { if !$0 { vm.selectedMedicineInfo = nil } }
                    )
                ) {
                    if let info = vm.selectedMedicineInfo {
                        MedicineInfoView(medicineInfo: info)
                            .environmentObject(vm)
                    }
                }
        }
    }
}

extension MedicalPreparetContentView {
    
    @ViewBuilder
    func contentView() -> some View {
        VStack(spacing: .zero) {
            TextField("Search for Medical", text: $vm.textFieldText)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 20.dpHeight())
                        .stroke(Color.customDarkBlue, lineWidth: 2)
                )
                .frame(height: 40.dpHeight())
                .padding(.horizontal, 16.dpWidth())
                .padding(.bottom, 16.dpHeight())
            
            if !vm.products.isEmpty {
                ScrollView(.vertical, showsIndicators: false) {
                    if vm.isLoading {
                        ProgressView()
                    } else {
                        ForEach(vm.products, id: \.id) { product in
                            VStack(alignment: .leading) {
                                Text(product.trade_name)
                                    .font(.sabFont(500, size: 19))
                                Text(product.country)
                                    .font(.sabFont(300, size: 16))
                                Divider()
                            }
                            .padding(.horizontal, 16.dpHeight())
                            .frame(height: 80.dpHeight())
                            .onTapGesture {
                                vm.sendProduct(product)
                            }
                        }
                    }
                }
            } else {
                VStack(spacing: 16.dpHeight()) {
                    Spacer()
                    Image(systemName: "magnifyingglass.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.customDarkBlue)
                    
                    Text("No products found")
                        .font(.sabFont(400, size: 18))
                        .foregroundColor(.customDarkBlue)
                    
                    Text("Try searching for a product using the search bar above.")
                        .font(.sabFont(300, size: 14))
                        .foregroundColor(.customDarkBlue.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32.dpWidth())
                    Spacer()
                }
            }
            
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient:
                    Gradient(colors: [Color.customLightBlue, Color(hex: "#F1FAEE")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

