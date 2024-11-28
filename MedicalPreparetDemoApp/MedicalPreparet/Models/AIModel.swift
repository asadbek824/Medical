//
//  AIModel.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/16/24.
//

import Foundation

// MARK: - Welcome
struct AIModel: Codable {
    let valid: Bool
    let data: WelcomeData
}

// MARK: - WelcomeData
struct WelcomeData: Codable {
    let message: Message
}

// MARK: - Message
struct Message: Codable {
    let type: Bool
    let data: MessageData
}

// MARK: - MessageData
struct MessageData: Codable {
    let medicineInfo: MedicineInfo

    enum CodingKeys: String, CodingKey {
        case medicineInfo = "medicine_info"
    }
}

// MARK: - MedicineInfo
struct MedicineInfo: Codable {
    let name, description, application, restrictions: String
    let manufacturer, countryOfOrigin: String
    let activeIngredients: [ActiveIngredient]

    enum CodingKeys: String, CodingKey {
        case name, description, application, restrictions, manufacturer
        case countryOfOrigin = "country_of_origin"
        case activeIngredients = "active_ingredients"
    }
}

// MARK: - ActiveIngredient
struct ActiveIngredient: Codable {
    let name, concentration, purpose: String
}
