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
    private let projectCreateModuleFactory: ProjectCreateModuleFactoryProtocol
    private let editorModuleFactory: EditorModuleFactoryProtocol
    private let mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    
    
    // MARK: - Init
    public init(
        context: EditorFlowContext,
        projectCreateModuleFactory: ProjectCreateModuleFactoryProtocol,
        editorModuleFactory: EditorModuleFactoryProtocol,
        mediaPermissionsModuleFactory: MediaPermissionsModuleFactoryProtocol
    ) {
        self.context = context
        self.projectCreateModuleFactory = projectCreateModuleFactory
        self.editorModuleFactory = editorModuleFactory
        self.mediaPermissionsModuleFactory = mediaPermissionsModuleFactory
    }
    
    deinit {
#if DEBUG
        print("Deinit EditorFlowCoordinator")
#endif
    }
    
    
    // MARK: - Child UI modules
    private weak var editorModuleInput: EditorModuleInput?
    private weak var projectCreateModuleInput: ProjectCreateModuleInput?
    
    
    // MARK: - EditorFlowModuleInput
    var onAction: ((EditorFlowModuleAction) -> Void)?
    
    func start(
        navigationController: UINavigationController,
        animated: Bool
    ) {
        // Initial root view controller. Later could be changed
        let initialRootViewController: UIViewController & DisposeBag
        
        // Choose initial root module accordingly to the context
        switch context {
        case .new:
            let module = createProjectCreateModule()
            self.projectCreateModuleInput = module.moduleInput
            initialRootViewController = module.viewController
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
        push(initialRootViewController, animated: animated)
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
    
    private func createProjectCreateModule() -> ProjectCreateModule {
        let module = projectCreateModuleFactory.module(moduleSeed: ProjectCreateModuleSeed())
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .selectVideo:
                self?.openMediaPicker()
            case .projectCreated(let project):
                self?.openProject(project, flushStack: true)
            case .close:
                self?.onAction?(.close)
            }
        }
        return module
    }
    
    private func createEditorModule(context: EditorContext) -> EditorModule {
        let module = editorModuleFactory.module(moduleSeed: EditorModuleSeed(context: context))
        module.moduleInput.onAction = { [weak self] action in
            switch action {
            case .close:
                self?.onAction?(.close)
            }
        }
        return module
    }
    
    private func openPermission() {
        
    }
    
    private func openProject(_ project: Project, flushStack: Bool) {
        let module = createEditorModule(context: .project(project))
        self.editorModuleInput = module.moduleInput
        if flushStack {
            // In case of replace we have to rebind lifecycle to the new root
            module.viewController.addDisposable(self)
            replace(with: [module.viewController], animated: true)
        } else {
            push(module.viewController, animated: true)
        }
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
        guard let projectCreateModuleInput else {
            assertionFailure("projectCreateModuleInput is nil while selectVideo()")
            return
        }
        let video = Video(url: videoUrl)
        projectCreateModuleInput.setVideo(video)
    }
}
