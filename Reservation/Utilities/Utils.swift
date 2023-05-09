//
//  Utils.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-09.
//

import Foundation
import NotificationBannerSwift

struct Utils {
    static func showBarnner(title: String, subtitle: String, style: BannerStyle = .info) {
        let banner = NotificationBanner(title: title, subtitle: subtitle, style: style)
        banner.show()
    }
}
