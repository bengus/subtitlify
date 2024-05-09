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
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .projectTap(let projectItem):
            projectTap(projectItem)
        }
    }
    
    private func projectTap(_ projectItem: ProjectListViewState.ProjectItem) {
        if let project = projectsProvider.getProjectById(projectItem.id) {
            onAction?(.openProject(project))
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
        case projectTap(projectItem: ProjectListViewState.ProjectItem)
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
}