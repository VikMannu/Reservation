//
//  JSONDecoder+Helpers.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    
    // Override the enum `JSONDecoder.DateDecodingStrategy` case `custom` which has an associated closure type.
    // See: https://stackoverflow.com/questions/46458487/how-to-convert-a-date-string-with-optional-fractional-seconds-using-codable-in-s
    static let customISO8601 = custom { decoder throws -> Date in
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        if let date = DateFormatter.rsk_ISO8601.date(from: string) {
            return date
        }
        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
