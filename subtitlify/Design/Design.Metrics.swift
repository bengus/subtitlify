//
//  Design.Metrics.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public extension Design {
    enum Metrics {
        public static let iconSize: CGFloat = 24
        public static let cornerRadius: CGFloat = 20
        public static let smallVerticalGap: CGFloat = 4
        public static let verticalGap: CGFloat = 10
        public static let bigVerticalGap: CGFloat = 20
        public static let smallHorizontalGap: CGFloat = 8
        public static let horizontalGap: CGFloat = 16
        public static let bigHorizontalGap: CGFloat = 36
        public static let topGap: CGFloat = 16
        public static let bottomGap: CGFloat = 16
        public static let borderWidth: CGFloat = 1 / UIScreen.main.scale
        public static let buttonCornerRadius: CGFloat = 12
        public static let buttonSolidContentInset = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        public static let buttonImageContentInset = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        public static let buttonSystemContentInset = NSDirectionalEdgeInsets(top: 8, leading: 4, bottom: 8, trailing: 4)
        public static let buttonHeight: CGFloat = 48
        public static let buttonWidth: CGFloat = 260
        public static let buttonWidthIpad: CGFloat = 320
    }
}
