//
//  Design.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public enum Design {
    public static var isIpad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // Here also should be code related to:
    // - switching between Dark theme and Light theme
    // - current skin in case of multiapps
}
