//
//  ProjectsProvider.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

private let projectsDefaultsKey = "ProjectsProvider_projects"

final class ProjectsProvider: ProjectsProviderProtocol {
    // To simplify a Demo use UserDefaults and Codable to save our projects
    private let defaults: UserDefaults
    private lazy var jsonEncoder = JSONEncoder()
    private lazy var jsonDecoder = JSONDecoder()
    
    
    // MARK: - Init
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    
    // MARK: - ProjectsProviderProtocol
    func getAllProjects() -> [Project] {
        if
            let projectsString = defaults.object(forKey: projectsDefaultsKey) as? String,
            let projectsData = projectsString.data(using: .utf8),
            let projects = try? jsonDecoder.decode([Project].self, from: projectsData)
        {
            return projects
        } else {
            return []
        }
    }
    
    func getProjectById(_ id: UUID) -> Project? {
        let projects = getAllProjects()
        return projects.first(where: { $0.id == id })
    }
    
    func saveProject(_ project: Project) async throws {
        var projects = getAllProjects()
        if let existingProjectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            projects[existingProjectIndex] = project
        } else {
            projects.append(project)
        }
        try await saveProjects(projects)
    }
    
    func saveProjects(_ projects: [Project]) async throws {
        let projectsData = try jsonEncoder.encode(projects)
        let projectsString = String(data: projectsData, encoding: .utf8)
        
        if let projectsString = projectsString {
            defaults.set(projectsString, forKey: projectsDefaultsKey)
        } else {
            defaults.removeObject(forKey: projectsDefaultsKey)
        }
    }
    
    func deleteProject(_ project: Project) async throws {
        var projects = getAllProjects()
        if let existingProjectIndex = projects.firstIndex(where: { $0.id == project.id }) {
            projects.remove(at: existingProjectIndex)
        }
        try await saveProjects(projects)
        // delete video file also
        Task(priority: .background) {
            do {
                try FileManager.default.removeItem(at: project.videoUrl)
            } catch(let error) {
                // Skip error handling because of demo
                // Do nothing
#if DEBUG
                print("ProjectsProvider error while removing video file")
                print(error.localizedDescription)
#endif
            }
        }
    }
}
