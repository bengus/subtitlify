//
//  Project.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public struct Project: Codable {
    public let id: UUID
    public let fileNameInDocumentsDirectory: String
    public let createdDate: Date
    public let subtitlesPosition: CGPoint?
    public let lastUsedCaptioningMode: CaptioningMode?
    
    // Because we shouldn't store absolute URL for documents directory.
    // It could be changed after reinstall
    public var videoUrl: URL {
        return MediaUtils.getDocumentsFileUrl(forFileName: fileNameInDocumentsDirectory)
    }
    
    public init(
        id: UUID,
        fileNameInDocumentsDirectory: String,
        createdDate: Date,
        subtitlesPosition: CGPoint?,
        lastUsedCaptioningMode: CaptioningMode?
    ) {
        self.id = id
        self.fileNameInDocumentsDirectory = fileNameInDocumentsDirectory
        self.createdDate = createdDate
        self.subtitlesPosition = subtitlesPosition
        self.lastUsedCaptioningMode = lastUsedCaptioningMode
    }
}
