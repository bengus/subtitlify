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
        public static func regular(ofSize size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        public static func semibold(ofSize size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .semibold)
        }
        
        public static func bold(ofSize size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .bold)
        }
        
        public static var navBarTitle: UIFont { semibold(ofSize: 17) }
        public static var navBarButton: UIFont { regular(ofSize: 17) }
        public static var tabBarTitle: UIFont { regular(ofSize: 11) }
        public static var defaultButton: UIFont { regular(ofSize: 16) }
        public static var defaultText: UIFont { regular(ofSize: 14) }
        public static var mediumText: UIFont { regular(ofSize: 16) }
        public static var bigText: UIFont { regular(ofSize: 18) }
        
        // Here should be also declared mostly all popular textstyles like
        // public static var heading1 = ...
        // public static var heading2 = ...
        // public static var body = ...
        // public static var caption = ...
    }
}
