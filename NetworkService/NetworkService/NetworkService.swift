//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Ismatillokhon   on 02/04/24.
//

import Foundation
import Combine
import UIKit

final public class NetworkService {
    
    private init() { }
    
    public static let shared = NetworkService()
    
    public func request<T: Decodable>(
        endpoint: String,
        decodeType: T.Type,
        method: HTTPMethod = .get,
        queryParameters: [String: String]? = nil,
        body: [String: Any]? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        
        let baseURL = "https://api.arzonapteka.name/api/"
        
        // Формируем URL с параметрами
        guard var components = URLComponents(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        if let queryParameters = queryParameters {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        // Устанавливаем заголовки
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        if let lang = UserDefaults.standard.string(forKey: "language") {
            request.setValue(lang, forHTTPHeaderField: "Accept-Language")
        }
        
        if let body = body {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        
        // Выполняем запрос
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.requestFailed
        }
        
        // Проверка статус-кодов
        switch httpResponse.statusCode {
        case 200..<300:
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        default:
            throw NetworkError.incorrectStatusCode(httpResponse.statusCode)
        }
    }
}
