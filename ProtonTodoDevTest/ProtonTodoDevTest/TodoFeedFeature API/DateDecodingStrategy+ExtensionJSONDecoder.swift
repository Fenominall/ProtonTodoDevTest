//
//  DateDecodingStrategy+ExtensionJSONDecoder.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/18/25.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601WithFractionalSeconds: JSONDecoder.DateDecodingStrategy = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            guard let date = formatter.date(from: dateString) else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
            return date
        }
    }()
}
