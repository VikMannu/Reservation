//
//  UIApplication+Helpers.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}
