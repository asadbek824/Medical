//
//  Codable+Extensions.swift
//  Core
//
//  Created by applebro on 17/08/24.
//

import Foundation

extension Encodable {
    public var jsonString: String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public func toDict() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) as? [String: Any]
    }
}
