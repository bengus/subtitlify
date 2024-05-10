//
//  PermissionsViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import Combine

class PermissionsViewModel:
    ViewModel
<
    PermissionsViewState,
    PermissionsViewModel.ViewAction,
    PermissionsViewModel.Eff
>,
    PermissionsModuleInput
{
    private let systemPermissionsProvider: SystemPermissionsProviderProtocol
    
    
    // MARK: - Init
    init(
        initialState: PermissionsViewState,
        systemPermissionsProvider: SystemPermissionsProviderProtocol
    ) {
        self.systemPermissionsProvider = systemPermissionsProvider
        super.init(initialState: initialState)
    }
    
    
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        reload()
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .askPermissionTap:
            askPermission()
        case .closeTap:
            close()
        }
    }
    
    private func askPermission() {
        if let firstMissingPermission = systemPermissionsProvider.getMissingPermissions().first {
            if firstMissingPermission.state == .primaryRequest {
                switch firstMissingPermission.permission {
                case .photoLibrary:
                    systemPermissionsProvider.requestPhotoLibraryPermission { [weak self] _ in
                        self?.checkAllGranted()
                    }
                case .speechRecognizer:
                    systemPermissionsProvider.requestSpeechRecognizerPermission { [weak self] _ in
                        self?.checkAllGranted()
                    }
                }
            } else if firstMissingPermission.state == .secondaryRequest {
                systemPermissionsProvider.openAppSettings()
                return
            }
        }
    }
    
    private func checkAllGranted() {
        if systemPermissionsProvider.getMissingPermissions().isEmpty {
            onAction?(.allGranted)
        } else {
            reload()
        }
    }
    
    private func close() {
        onAction?(.close)
    }
    
    /// Each time you want, you can rebuild current view state publish it for view with "reload"
    private func reload() {
        let state: PermissionsViewState
        if let firstMissingPermission = systemPermissionsProvider.getMissingPermissions().first {
            let titleText: String
            let subtitleText: String
            let buttonText: String
            let imageName: String?
            switch firstMissingPermission.permission {
            case .photoLibrary:
                titleText = "Photos"
                subtitleText = if firstMissingPermission.state == .primaryRequest {
                    "We kindly ask you to provide an access to your Photos to pick videos for captioning.\nTap \"Request\" to provide an access."
                } else {
                    "We kindly ask you to provide an access to your Photos to pick videos for captioning.\nYou can enable it in Settings app. Tap \"Go to settings\"."
                }
                imageName = "apple_photos"
            case .speechRecognizer:
                titleText = "SpeechRecognition"
                subtitleText =  if firstMissingPermission.state == .primaryRequest {
                    "We need to access to SpeechRecognition services on your device to make captioning for videos.\nTap \"Request\" to provide an access."
                } else {
                    "We need to access to SpeechRecognition services on your device to make captioning for videos.\nYou can enable it in Settings app. Tap \"Go to settings\"."
                }
                imageName = "apple_speech_recognizer"
            }
            buttonText = if firstMissingPermission.state == .primaryRequest {
                "Request"
            } else {
                "Go to settings"
            }
            state = PermissionsViewState(
                isLoading: false,
                titleText: titleText,
                subtitleText: subtitleText,
                buttonText: buttonText,
                imageName: imageName
            )
        } else {
            state = .empty()
        }
        
        publishState(
            state
        )
    }
    
    
    // MARK: - PermissionsModuleInput
    var onAction: ((PermissionsModuleAction) -> Void)?
}

extension PermissionsViewModel {
    /// Actions that could published from View
    enum ViewAction {
        case askPermissionTap
        case closeTap
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
}
