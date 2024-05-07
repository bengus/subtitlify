//
//  Design.Colors.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public extension Design {
    /// This is Functional Palette, should be used in public code
    enum Colors {
        // Emotional control state
        public static var accent: UIColor { Palette.magicInk }
        public static var positive: UIColor { Palette.green }
        public static var negative: UIColor { Palette.red }
        public static var info: UIColor { Palette.grey2 }
        public static var disabled: UIColor { Palette.grey3 }
        // Text
        public static var primaryText: UIColor { Palette.black }
        public static var secondaryText: UIColor { Palette.grey }
        public static var lightText: UIColor { Palette.white }
        public static var linksText: UIColor { Palette.blue }
        // Other Views-related
        public static var border: UIColor { Palette.grey1 }
        public static var borderDisabled: UIColor { Palette.grey4 }
        public static var defaultBackground: UIColor { Palette.white }
        public static var darkBackground: UIColor { Palette.pianoBlack }
        public static var loadingIndicatorGrey: UIColor { Palette.grey }
        public static var loadingIndicatorWhite: UIColor { Palette.white }
        public static var loadingBackdropColor: UIColor { Palette.black.withAlphaComponent(0.3) }
        public static var navBarText: UIColor { Palette.black }
        public static var navBarBackground: UIColor { Palette.white }
        public static var tabBarText: UIColor { Palette.grey }
        public static var tabBarSelectedText: UIColor { Palette.black }
        public static var tabBarBackround: UIColor { Palette.white }
        public static var playbackBackround: UIColor { Palette.pianoBlack }
    }
}

public extension Design.Colors {
    /// This is raw Palette from Designers, please avoid to use it directly. Try to use functional colors from Design.Colors.
    /// If you really need to use colors from this Palette, please wrap it in "private extension Design.Colors" in a specific View
    enum Palette {
        public static var black: UIColor { UIColor(hexString: "#2d333a") }
        public static var grey: UIColor { UIColor(hexString: "#565859") }
        public static var grey1: UIColor { UIColor(hexString: "#D0D7D9") }
        public static var grey2: UIColor { UIColor(hexString: "#E7E7E7") }
        public static var grey3: UIColor { UIColor(hexString: "#CCCDCD") }
        public static var grey4: UIColor { UIColor(hexString: "#F1F3F4") }
        public static var white: UIColor { UIColor(hexString: "#FFFFFF") }
        public static var red: UIColor { UIColor(hexString: "#FF6969") }
        public static var green: UIColor { UIColor(hexString: "#33CC8C") }
        public static var blue: UIColor { UIColor(hexString: "#3B82F6") }
        public static var pianoBlack: UIColor { UIColor(hexString: "#15161a") }
        public static var magicInk: UIColor { UIColor(hexString: "#0A49EB") }
    }
}
