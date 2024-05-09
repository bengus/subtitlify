//
//  Project.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public struct Project: Codable {
    public let id: UUID
    public let videoUrl: URL
    public let createdDate: Date
//    public let lastUsedCaptioningMode: CaptioningMode
    
    
    public init(
        id: UUID,
        videoUrl: URL,
        createdDate: Date
    ) {
        self.id = id
        self.videoUrl = videoUrl
        self.createdDate = createdDate
    }
}
