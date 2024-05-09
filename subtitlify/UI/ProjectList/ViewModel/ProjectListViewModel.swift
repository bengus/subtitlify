//
//  ProjectListViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

class ProjectListViewModel:
    ViewModel
<
    ProjectListViewState,
    ProjectListViewModel.ViewAction,
    ProjectListViewModel.Eff
>,
    ProjectListModuleInput
{
    private let projectsProvider: ProjectsProviderProtocol
    private var projectDeletingTask: Task<Void, Never>?
    
    
    // MARK: - Init
    init(
        initialState: ProjectListViewState,
        projectsProvider: ProjectsProviderProtocol
    ) {
        self.projectsProvider = projectsProvider
        super.init(initialState: initialState)
    }
    
    
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        // Start listening IAPProvider
        reload()
    }
    
    override func onViewWillDisappear() {
        super.onViewWillDisappear()
        projectDeletingTask?.cancel()
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .createProjectTap:
            createProjectTap()
        case .projectTap(let projectItem):
            projectTap(projectItem)
        case .deleteProject(let projectItem):
            deleteProject(projectItem: projectItem)
        }
    }
    
    private func createProjectTap() {
        onAction?(.createProject)
    }
    
    private func projectTap(_ projectItem: ProjectListViewState.ProjectItem) {
        if let project = projectsProvider.getProjectById(projectItem.id) {
            onAction?(.openProject(project))
        }
    }
    
    private func deleteProject(projectItem: ProjectListViewState.ProjectItem) {
        projectDeletingTask = Task(priority: .background) {
            if let project = projectsProvider.getProjectById(projectItem.id) {
                try? await projectsProvider.deleteProject(project)
                await MainActor.run {
                    reload()
                }
            }
        }
    }
    
    private func reload() {
        let projects = projectsProvider.getAllProjects()
        let projectItems = projects.map({
            ProjectListViewState.ProjectItem.from(project: $0)
        })
        
        publishState(
            ProjectListViewState(
                projects: projectItems,
                isLoading: false
            )
        )
    }
    
    
    // MARK: - ProjectListModuleInput
    var onAction: ((ProjectListModuleAction) -> Void)?
}

extension ProjectListViewModel {
    /// Actions that could published from View
    enum ViewAction {
        case createProjectTap
        case projectTap(projectItem: ProjectListViewState.ProjectItem)
        case deleteProject(projectItem: ProjectListViewState.ProjectItem)
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
}
