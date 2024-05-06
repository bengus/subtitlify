//
//  UIApplication+KeyWindow.swift
//
//
//  Created by Boris Bengus on 21/01/2024.
//

import Foundation
import UIKit

public extension UIApplication {
    func findKeyWindow() -> UIWindow? {
        connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow }).first
    }
}
