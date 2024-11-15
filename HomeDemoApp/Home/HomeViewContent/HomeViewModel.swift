//
//  HomeViewModel.swift
//  Home
//
//  Created by Asadbek Yoldoshev on 11/14/24.
//

import SwiftUI
import HealthKit

final class HomeViewModel: ObservableObject {
    private let healthStore = HKHealthStore()
    
    @Published var heartRate: Double = 0
    @Published var spO2: Double = 0
    @Published var bodyTemperature: Double = 0
    @Published var steps: Double = 0
    @Published var respiratoryRate: Double = 0
    @Published var activeEnergyBurned: Double = 0
    
    private var timer: Timer?
    
    init() {
        requestHealthKitAuthorization()
        
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.fetchLatestData()
        }
    }
    
    private func requestHealthKitAuthorization() {
        let typesToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .oxygenSaturation)!,
            HKObjectType.quantityType(forIdentifier: .bodyTemperature)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .respiratoryRate)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            if success {
                self.fetchLatestData()
            } else if let error = error {
                print("HealthKit authorization failed: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchLatestData() {
        fetchHeartRate()
        fetchSpO2()
        fetchBodyTemperature()
        fetchSteps()
        fetchRespiratoryRate()
        fetchActiveEnergyBurned()
    }
    
    private func fetchHeartRate() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else { return }
        
        let query = HKSampleQuery(sampleType: heartRateType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let sample = samples?.first as? HKQuantitySample {
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let heartRateValue = sample.quantity.doubleValue(for: heartRateUnit)
                DispatchQueue.main.async {
                    self.heartRate = heartRateValue
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchSpO2() {
        guard let spO2Type = HKObjectType.quantityType(forIdentifier: .oxygenSaturation) else { return }
        
        let query = HKSampleQuery(sampleType: spO2Type, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let sample = samples?.first as? HKQuantitySample {
                let spO2Unit = HKUnit.percent()
                let spO2Value = sample.quantity.doubleValue(for: spO2Unit) * 100
                DispatchQueue.main.async {
                    self.spO2 = spO2Value
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchBodyTemperature() {
        guard let bodyTempType = HKObjectType.quantityType(forIdentifier: .bodyTemperature) else { return }
        
        let query = HKSampleQuery(sampleType: bodyTempType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let sample = samples?.first as? HKQuantitySample {
                let temperatureUnit = HKUnit.degreeFahrenheit()
                let temperatureValue = sample.quantity.doubleValue(for: temperatureUnit)
                DispatchQueue.main.async {
                    self.bodyTemperature = temperatureValue
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchSteps() {
        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else { return }
        
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
            if let sum = result?.sumQuantity() {
                let steps = sum.doubleValue(for: HKUnit.count())
                DispatchQueue.main.async {
                    self.steps = steps
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchRespiratoryRate() {
        guard let respiratoryRateType = HKObjectType.quantityType(forIdentifier: .respiratoryRate) else { return }
        
        let query = HKSampleQuery(sampleType: respiratoryRateType, predicate: nil, limit: 1, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { _, samples, _ in
            if let sample = samples?.first as? HKQuantitySample {
                let respiratoryRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                let respiratoryRateValue = sample.quantity.doubleValue(for: respiratoryRateUnit)
                DispatchQueue.main.async {
                    self.respiratoryRate = respiratoryRateValue
                }
            }
        }
        healthStore.execute(query)
    }
    
    private func fetchActiveEnergyBurned() {
        guard let energyBurnedType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        
        let query = HKStatisticsQuery(quantityType: energyBurnedType, quantitySamplePredicate: nil, options: .cumulativeSum) { _, result, _ in
            if let sum = result?.sumQuantity() {
                let energyBurned = sum.doubleValue(for: HKUnit.kilocalorie())
                DispatchQueue.main.async {
                    self.activeEnergyBurned = energyBurned
                }
            }
        }
        healthStore.execute(query)
    }
    
    func formattedValue(_ value: Double) -> String {
        return value > 0 ? String(format: "%.1f", value) : "N/A"
    }
    
    deinit {
        timer?.invalidate()
    }
}
