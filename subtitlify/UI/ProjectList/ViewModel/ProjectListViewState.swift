//
//  ProjectListViewState.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

// It could be better to create separate place for formatting logic and configuration.
// Skip because of demo
private let dateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMMM yyyy"
    return dateFormatter
}()
    

struct ProjectListViewState: Equatable {
    let projects: [ProjectItem]
    let isLoading: Bool
    
    static func empty() -> Self {
        return ProjectListViewState(
            projects: [],
            isLoading: false
        )
    }
}

extension ProjectListViewState {
    struct ProjectItem: Equatable {
        let id: UUID
        let dateText: String
        let image: UIImage?
        
        static func == (lhs: ProjectListViewState.ProjectItem, rhs: ProjectListViewState.ProjectItem) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension ProjectListViewState.ProjectItem {
    static func from(project: Project) -> Self {
        return .init(
            id: project.id,
            dateText: dateFormatter.string(from: project.createdDate),
            // Not so good Idea to ask it synchronously, for demo case only
            image: MediaUtils.previewImageFromVideo(url: project.videoUrl)
        )
    }
}
