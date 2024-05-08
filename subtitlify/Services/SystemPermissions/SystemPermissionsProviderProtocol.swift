//
//  SystemPermissionsProviderProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

protocol SystemPermissionsProviderProtocol {
    func getMissingPermissions(completion: @escaping ([SystemPermissionRequest]) -> Void)
    
    func requestSpeechRecognizerPermission(completion: @escaping (Bool) -> Void)
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void)
}
