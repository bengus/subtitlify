//
//  SystemPermissionsProvider.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation
import Speech
import Photos
import UIKit
import CoreLocation

final class SystemPermissionsProvider: SystemPermissionsProviderProtocol {
    // MARK: - Init
    init() { }
    
    
    // MARK: - SystemPermissionsProviderProtocol
    func getMissingPermissions() -> [SystemPermissionRequest] {
        var result = [SystemPermissionRequest]()
        
        let photosPermissionState = getPhotosPermissionState()
        switch photosPermissionState {
        case .primaryRequest, .secondaryRequest:
            result.append(SystemPermissionRequest(permission: .photoLibrary, state: photosPermissionState))
        default:
            break
        }
        
        let speechRecognizerPermissionState = getSpeechRecognizerPermissionState()
        switch speechRecognizerPermissionState {
        case .primaryRequest, .secondaryRequest:
            result.append(SystemPermissionRequest(permission: .speechRecognizer, state: speechRecognizerPermissionState))
        default:
            break
        }
        
        return result
    }
    
    func requestSpeechRecognizerPermission(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            assert(status == .authorized)
            DispatchQueue.main.async {
#if DEBUG
                print("SFSpeechRecognizer permission granted")
#endif
                completion(status == .authorized)
            }
        }
    }
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        MediaUtils.requestPhotoLibraryAuthorization(completion: completion)
    }
    
    private func getPhotosPermissionState() -> SystemPermissionRequest.State {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            return .denied
        case .limited:
            return .denied
        case .denied:
            return .secondaryRequest
        case .notDetermined:
            return .primaryRequest
        case .restricted:
            return .denied
        @unknown default:
            return .denied
        }
    }
    
    private func getSpeechRecognizerPermissionState() -> SystemPermissionRequest.State {
        switch SFSpeechRecognizer.authorizationStatus() {
        case .notDetermined:
            return .primaryRequest
        case .denied:
            return .secondaryRequest
        case .restricted:
            return .denied
        case .authorized:
            return .denied
        @unknown default:
            return .denied
        }
    }
    
    func openAppSettings() {
        if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(
                settingsURL,
                options: [:],
                completionHandler: nil
            )
        }
    }
}
