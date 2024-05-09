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
                        self?.reload()
                    }
                case .speechRecognizer:
                    systemPermissionsProvider.requestSpeechRecognizerPermission { [weak self] _ in
                        self?.reload()
                    }
                }
            } else if firstMissingPermission.state == .secondaryRequest {
                systemPermissionsProvider.openAppSettings()
                return
            }
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
                titleText = "Access to Photos"
                subtitleText = if firstMissingPermission.state == .primaryRequest {
                    "We kindly ask you to provide an access to your Photos to pick videos for captioning🙏. Tap \"Request\" to provide an access."
                } else {
                    "We kindly ask you to provide an access to your Photos to pick videos for captioning🙏. You can enable it in Settings app. Tap \"Go to settings\"."
                }
                imageName = "icn_photos"
            case .speechRecognizer:
                titleText = "Access to SpeechRecognition"
                subtitleText =  if firstMissingPermission.state == .primaryRequest {
                    "We need to access to SpeechRecognition services on your device to make captioning for videos🙏. Tap \"Request\" to provide an access."
                } else {
                    "We need to access to SpeechRecognition services on your device to make captioning for videos🙏. You can enable it in Settings app. Tap \"Go to settings\"."
                }
                imageName = "icn_mic"
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
