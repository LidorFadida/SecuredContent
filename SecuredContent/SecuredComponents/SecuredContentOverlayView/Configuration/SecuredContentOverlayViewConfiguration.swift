//
//  SecuredContentOverlayViewConfiguration.swift
//  SecuredContent
//
//  Created by Lidor Fadida on 23/06/2024.
//

import UIKit

struct SecuredContentOverlayViewConfiguration {
    let icon: UIImage
    let title: String
    let subtitle: String?
    
    init(
        icon: UIImage,
        title: String,
        subtitle: String? = nil
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
    }
}
