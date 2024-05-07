//
//  EditorFlowCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import AVFoundation

final class EditorFlowCoordinator: NavigationCoordinator,
                                   EditorFlowModuleInput
{
    private let editorModuleFactory: EditorModuleFactoryProtocol
    private let mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        editorModuleFactory: EditorModuleFactoryProtocol,
        mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    ) {
        self.editorModuleFactory = editorModuleFactory
        self.mediaPermissionsModuleFactory = mediaPermissionsModuleFactory
    }
    
    
    // MARK: - Child UI modules
    private weak var editorModuleInput: EditorModuleInput?
    
    
    // MARK: - EditorFlowModuleInput
    var onAction: ((EditorFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        let editorModule = editorModuleFactory.module(moduleSeed: EditorModuleSeed())
        editorModule.moduleInput.onAction = { [weak self] action in
            switch action {
            case .selectVideo:
                self?.selectVideo()
            case .close:
                self?.onAction?(.close)
            }
        }
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle (see configure)
        configure(
            navigationController: navigationController,
            rootViewController: editorModule.viewController
        )
        // hold module input as weak reference
        self.editorModuleInput = editorModule.moduleInput
        push(editorModule.viewController, animated: false)
    }
    
    
    // MARK: - Coordinator
    private func selectVideo() {
        let demoVideoURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
        let demoVideo = Video(url: demoVideoURL)
        
        guard let editorModuleInput = editorModuleInput else {
            assertionFailure("editorModuleInput is nil while selectVideo()")
            return
        }
        editorModuleInput.setVideo(demoVideo)
    }
}
