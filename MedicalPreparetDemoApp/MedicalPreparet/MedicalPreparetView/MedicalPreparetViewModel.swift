//
//  MedicalPreparetViewModel.swift
//  MedicalPreparet
//
//  Created by Asadbek Yoldoshev on 11/15/24.
//

import Combine
import SwiftUI
import NetworkManager

final class MedicalPreparetViewModel: ObservableObject {
    
    @Published var textFieldText: String = ""
    @Published var products: [ProductsModel] = []
    @Published var isLoading: Bool = false
    @Published var selectedMedicineInfo: MedicineInfo? = nil
    @Published var chatText: String = ""
    @Published var aiText: String = ""
    @Published var analogProducts: AnalogProductsModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Observe changes to `textFieldText` and debounce to reduce network calls
        $textFieldText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard !searchText.isEmpty else {
                    self?.products = [] // Clear results if text is empty
                    return
                }
                self?.fetchProducts()
            }
            .store(in: &cancellables)
    }
    
    func fetchProducts() {
        let urlString = "http://172.16.18.134:44444/search"
        let hearder = [
            "trade_name" : textFieldText
        ]
        Task.detached {
            do {
                let model = try await NetworkService.shared.request(
                    url: urlString,
                    decode: [ProductsModel].self,
                    method: .get,
                    queryParameters: hearder
                )
                
                await MainActor.run { [weak self] in
                    self?.products = model
                }
            } catch {
                
            }
        }
    }
    
    func sendProduct(_ selectedProduct: ProductsModel) {
        isLoading = true
        let urlString = "http://172.16.18.134:44444/aisearch"
        let query = [
            "metadata" : "\(selectedProduct)"
        ]
        Task.detached {
            do {
                let model = try await NetworkService.shared.request(
                    url: urlString,
                    decode: AIModel.self,
                    method: .post,
                    queryParameters: query
                )
                
                await MainActor.run { [weak self] in
                    self?.isLoading = false
                    self?.selectedMedicineInfo = model.data.message.data.medicineInfo
                    self?.analogsProducts()
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.isLoading = false
                    print(error)
                }
            }
        }
    }

    func analogsProducts() {
        isLoading = true
        let urlString = "http://172.16.18.134:44444/analogs"
        let body: [String : Any] = [
            "input_data" : selectedMedicineInfo?.name ?? ""
        ]
        Task.detached {
            do {
                let model = try await NetworkService.shared.request(
                    url: urlString,
                    decode: AnalogProductsModel.self,
                    method: .post,
                    body: body
                )
                
                await MainActor.run { [weak self] in
                    self?.analogProducts = model
                    self?.isLoading = false
                }
            } catch {
                await MainActor.run { [weak self] in
                    self?.isLoading = false
                    print(error)
                }
            }
        }
    }
}
