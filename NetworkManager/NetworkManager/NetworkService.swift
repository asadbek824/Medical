//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Ismatillokhon   on 02/04/24.
//

import Foundation
import Combine
import UIKit

struct NetworkServiceConfig {
    static var isLogEnabled = true
}
let showJsonLog = true

final public class NetworkService {
    
    private init() { }
    
    public static let shared = NetworkService()
    
    public func request<T: Decodable>(
        url: String,
        decode: T.Type,
        method: HTTPMethod,
        queryParameters: [String: String]? = nil,
        body: [String: Any]? = nil,
        header: [String: String] = [:]
    ) async throws -> T {
        
        guard var components = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        self.log("REQUEST------------------ \(url)", force: true)
        
        // Add query parameters to the URL if provided
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            self.log("queryParameters: \(queryParameters)", force: true)
        }
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
    
        // set header
        self.log("-------------------------HEADER---------------------------------")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        self.log("Content-Type", "application/json","\n")
        request.setValue("iOS", forHTTPHeaderField: "Accept-Device")
        
        if let lang = UserDefaults.standard.object(forKey: "language") as? String {
            request.setValue(lang, forHTTPHeaderField: "Accept-Language")
            print("language header", lang)
        }
        
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Authorization", "Bearer", "TOKEN", token,"\n")
        }
        if !header.isEmpty {
            header.forEach { (key, value) in
                request.setValue(key, forHTTPHeaderField: value)
            }
        }
        
        if let deviceId = await UIDevice.current.identifierForVendor?.uuidString {
            request.setValue(deviceId, forHTTPHeaderField: "Accept-DeviceId")
            self.log("DeviceId", deviceId, force: true)
        }
        
        if let countryCode = UserDefaults.standard.string(forKey: "countryCode") {
            request.setValue(countryCode.lowercased(), forHTTPHeaderField: "Accept-Country")
            print("NetworkService \(countryCode)")
        }
        
        // Add request body if provided
        if var body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            self.log("body: \(body)", force: true)
        } else {
            self.log("BODY IS EMPTY", url)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            
            guard let safeResponse = response as? HTTPURLResponse,
                      safeResponse.statusCode >= 200,
                      safeResponse.statusCode < 300
            else {
                guard let response = (response as? HTTPURLResponse) else { throw NetworkError.requestFailed }
                
                if response.statusCode == 401 {
                    logOutOrDeleteAccountAction()
                }
                
                self.log("error with code: \(response.statusCode)")
                throw NetworkError.incorrectStatusCode(response.statusCode)
            }
            
            self.log("in model", T.self, "✅", force: true)
           
            #if DEBUG
            print(url, try JSONSerialization.jsonObject(with: data))
            self.log("\(try JSONSerialization.jsonObject(with: data))")
            #endif
            if showJsonLog {
                print(try JSONSerialization.jsonObject(with: data))
            }
            let decoder = JSONDecoder()
            let decodedObject = try decoder.decode(T.self, from: data)
            print(try decoder.decode(T.self, from: data))
            return decodedObject
        } catch {
            self.log(
                "in model", T.self,
                "🛑🛑🛑🛑🛑🛑🛑 DECODE ERROR",
                error,
                force: true
            )
            print(error)
            throw error
        }
    }
    
    public func getTransactionID(transaction: @escaping(TransactionModel) -> ()) {
        Task.detached {
            do {
                let success = try await self.request(
                    url: "https://prod.7saber.uz/api/client/card/generate-transaction-id",
                    decode: TransactionModel.self,
                    method: .get
                )
                
                await MainActor.run {
                    transaction(success)
                }
            } catch {
                self.log("ERROR on getting Transaction", error.localizedDescription)
            }
        }
    }
}

public struct TransactionModel: Codable {
    public let paymentID, requesterID: Int
    public let transactionID, token, type: String
    public let amount: Int
    public let currency, status, language, createdDate: String
    public let paymentURL: String
    public let lastModifiedDate: String

    public enum CodingKeys: String, CodingKey {
        case paymentID = "paymentId"
        case requesterID = "requesterId"
        case transactionID = "transactionId"
        case token, type, amount, currency, status, language, createdDate
        case paymentURL = "paymentUrl"
        case lastModifiedDate
    }
}

func logOutOrDeleteAccountAction() {
    UserDefaults.standard.removeObject(forKey: "token")
}
