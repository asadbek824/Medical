//
//  ProductsModel.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import Foundation

struct ProductsModel: Codable {
    let id: Int
    let trade_name: String
    let intl_name: String
    let dosage_form: String
    let country: String
    let manufacturer: String
    let pharma_group: String
    let atx_code: String
    let reg_num_new: String
    let reg_date_new: String
}
