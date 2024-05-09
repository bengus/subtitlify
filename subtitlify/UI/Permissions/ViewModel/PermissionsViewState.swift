//
//  PermissionsViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import AVFoundation

struct PermissionsViewState: Equatable {
    let isLoading: Bool
    let titleText: String
    let subtitleText: String
    let buttonText: String
    let imageName: String?
    
    static func empty() -> Self {
        return PermissionsViewState(
            isLoading: false,
            titleText: "",
            subtitleText: "",
            buttonText: "",
            imageName: nil
        )
    }
}
