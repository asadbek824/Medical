//
//  AnalogProductsModel.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/16/24.
//

import Foundation

struct AnalogProductsModel: Codable {
    let analogs: [Analog]
}

// MARK: - Analog
struct Analog: Codable {
    let name, country, company: String
}
