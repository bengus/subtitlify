//
//  ProjectsError.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

public enum ProjectsError: Error {
    case projectSavingFailed(reason: Error)
    case projectDeletionFailed(reason: Error)
}
