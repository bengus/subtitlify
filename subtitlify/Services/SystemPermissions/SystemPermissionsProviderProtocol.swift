//
//  SystemPermissionsProviderProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public protocol SystemPermissionsProviderProtocol {
    func getMissingPermissions() -> [SystemPermissionRequest]
    func requestSpeechRecognizerPermission(completion: @escaping (Bool) -> Void)
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void)
    func openAppSettings()
}
