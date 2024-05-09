//
//  ProjectsProviderProtocol.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public protocol ProjectsProviderProtocol {
    func getAllProjects() -> [Project]
    func saveProject(_ project: Project) async throws
    func saveProjects(_ projects: [Project]) async throws
    func deleteProject(_ project: Project) async throws
}
