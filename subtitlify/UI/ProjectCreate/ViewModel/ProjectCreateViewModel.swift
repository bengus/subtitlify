//
//  ProjectCreateViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import Combine

class ProjectCreateViewModel:
    ViewModel
<
    ProjectCreateViewState,
    ProjectCreateViewModel.ViewAction,
    ProjectCreateViewModel.Eff
>,
    ProjectCreateModuleInput
{
    private let projectsProvider: ProjectsProviderProtocol
    private var projectCreatingTask: Task<Void, Never>?
    private var isProjectCreatingInProgress: Bool {
        return !(projectCreatingTask?.isCancelled ?? true)
    }
    
    
    // MARK: - Init
    init(
        initialState: ProjectCreateViewState,
        projectsProvider: ProjectsProviderProtocol
    ) {
        self.projectsProvider = projectsProvider
        super.init(initialState: initialState)
    }
    
    
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        reload()
    }
    
    override func onViewWillDisappear() {
        super.onViewWillDisappear()
        projectCreatingTask?.cancel()
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .selectVideoTap:
            selectVideo()
        case .closeTap:
            close()
        }
    }
    
    private func selectVideo() {
        onAction?(.selectVideo)
    }
    
    private func close() {
        onAction?(.close)
    }
    
    /// Each time you want, you can rebuild current view state publish it for view with "reload"
    private func reload() {
        publishState(
            ProjectCreateViewState(
                isLoading: isProjectCreatingInProgress
            )
        )
    }
    
    
    // MARK: - ProjectCreateModuleInput
    var onAction: ((ProjectCreateModuleAction) -> Void)?
    
    func setVideo(_ video: Video) {
        projectCreatingTask = Task(priority: .background) {
            // don't worry about [weak self] and retain cycle because we cancel the task on viewWillDisappear
            
            do {
                // Encode video to mp4
                let encodedVideo = try await MediaUtils.encodeVideoToMp4(videoUrl: video.url)
                // Save to documents directory
                let fileName = MediaUtils.getUniqueMediaFileName(withExt: MediaUtils.mediaFileTypeMp4)
                let movedToDocumentsVideo = MediaUtils.movedVideoToDocumentsDirectory(
                    encodedVideo,
                    newFileName: fileName
                )
                // Create and save our project
                let project = Project(
                    id: UUID(),
                    videoUrl: movedToDocumentsVideo.url,
                    createdDate: Date()
                )
                try await projectsProvider.saveProject(project)
                
                await MainActor.run {
                    onAction?(.projectCreated(project))
                }
            } catch (let error) {
                // Skip error handling because of demo
                // Do nothing
#if DEBUG
                print("ProjectCreateViewModel error while encoding video")
                print(error.localizedDescription)
#endif
            }
        }
        reload()
    }
}

extension ProjectCreateViewModel {
    /// Actions that could published from View
    enum ViewAction {
        case selectVideoTap
        case closeTap
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
}
