//
//  Project.swift
//  subtitlify
//
//  Created by Boris Bengus on 08/05/2024.
//

import Foundation

public struct Project: Codable {
    public let videoUrl: URL
    
    public init(videoUrl: URL) {
        self.videoUrl = videoUrl
    }
}
