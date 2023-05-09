//
//  Encodable+Helpers.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

extension Encodable {
    var rsk_dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
