//
//  String+Helpers.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation

extension String {
    func trimmed() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
