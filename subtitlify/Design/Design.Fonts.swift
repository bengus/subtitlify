//
//  Design.Fonts.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public extension Design {
    enum Fonts {
        public static var navBarTitle: UIFont { UIFont.systemFont(ofSize: 17, weight: .semibold) }
        public static var navBarButton: UIFont { UIFont.systemFont(ofSize: 17, weight: .regular) }
        public static var tabBarTitle: UIFont { UIFont.systemFont(ofSize: 11, weight: .regular) }
        public static var defaultButton: UIFont { UIFont.systemFont(ofSize: 16, weight: .regular) }
        public static var defaultText: UIFont { UIFont.systemFont(ofSize: 14, weight: .regular) }
        public static var mediumText: UIFont { UIFont.systemFont(ofSize: 16, weight: .regular) }
        public static var bigText: UIFont { UIFont.systemFont(ofSize: 18, weight: .regular) }
        
        // Here should be also declared mostly all popular textstyles like
        // public static var heading1 = ...
        // public static var heading2 = ...
        // public static var body = ...
        // public static var caption = ...
    }
}
