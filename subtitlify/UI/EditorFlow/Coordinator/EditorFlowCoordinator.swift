//
//  EditorFlowCoordinator.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import AVFoundation
import UniformTypeIdentifiers

final class EditorFlowCoordinator: NavigationCoordinator,
                                   EditorFlowModuleInput
{
    private let context: EditorFlowContext
    private let editorModuleFactory: EditorModuleFactoryProtocol
    private let mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        context: EditorFlowContext,
        editorModuleFactory: EditorModuleFactoryProtocol,
        mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    ) {
        self.context = context
        self.editorModuleFactory = editorModuleFactory
        self.mediaPermissionsModuleFactory = mediaPermissionsModuleFactory
    }
    
    
    // MARK: - Child UI modules
    private weak var editorModuleInput: EditorModuleInput?
    
    
    // MARK: - EditorFlowModuleInput
    var onAction: ((EditorFlowModuleAction) -> Void)?
    
    func start(navigationController: UINavigationController) {
        // Initial root view controller. Later could be changed
        let initialRootViewController: UIViewController & DisposeBag
        
        // Choose initial root module accordingly to the context
        switch context {
        case .new:
            openVideoPicker()
            initialRootViewController = BaseViewController()
        case .demo(let isBuffered):
            let module = createEditorModule(context: .demo(isBuffered: isBuffered))
            self.editorModuleInput = module.moduleInput
            initialRootViewController = module.viewController
        case .project(let project):
            let module = createEditorModule(context: .project(project))
            self.editorModuleInput = module.moduleInput
            initialRootViewController = module.viewController
        }
        
        // Lifecycle of the NavigationCoordinator should follow the root viewcontroller lificycle (see configure)
        configure(
            navigationController: navigationController,
            rootViewController: initialRootViewController
        )
        push(initialRootViewController, animated: false)
    }
    
    
    // MARK: - Coordinator
    private lazy var imagePickerDelegate = ImagePickerDelegateProxy(
        onFinishPickingMediaWithInfo: { [weak self] picker, info in
            if let videoUrl = info[.mediaURL] as? URL {
                picker.dismiss(animated: true) { [weak self] in
                    self?.selectVideo(videoUrl: videoUrl)
                }
            } else {
                picker.dismiss(animated: true)
            }
        },
        onCancel: { [weak self] picker in
            picker.dismiss(animated: true)
        }
    )
    
    private func openVideoPicker() {
        
    }
    
    private func createEditorModule(context: EditorContext) -> EditorModule {
        let editorModule = editorModuleFactory.module(moduleSeed: EditorModuleSeed(context: context))
        editorModule.moduleInput.onAction = { [weak self] action in
            switch action {
            case .selectVideo:
                self?.openMediaPicker()
            case .close:
                self?.onAction?(.close)
            }
        }
        return editorModule
    }
    
    private func openPermission() {
        
    }
    
    private func openMediaPicker() {

        
        MediaUtils.requestPhotoLibraryAuthorization { [weak self] authorized in
            guard let self else { return }
            
            let mediaPicker = UIImagePickerController()
            mediaPicker.sourceType = .photoLibrary
            mediaPicker.mediaTypes = [UTType.movie.identifier]
            mediaPicker.allowsEditing = true
            mediaPicker.delegate = self.imagePickerDelegate
            navigationController?.present(mediaPicker, animated: true, completion: nil)
        }
    }
    
    func selectVideo(videoUrl: URL) {
//        guard let editorModuleInput = editorModuleInput else {
//            assertionFailure("editorModuleInput is nil while selectVideo()")
//            return
//        }
//        let video = Video(url: videoUrl)
//        editorModuleInput.setVideo(video)
    }
}
