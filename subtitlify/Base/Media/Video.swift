//
//  Video.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import CoreMedia
import AVFoundation

public struct Video {
    public let url: URL
    public let asset: AVURLAsset
    
    public var duration: CMTime {
        return asset.duration
    }
    
    public var durationSeconds: TimeInterval {
        return CMTimeGetSeconds(duration)
    }
    
    public var fileName: String {
        return url.lastPathComponent
    }
    
    public init(url: URL) {
        self.url = url
        self.asset = AVURLAsset(url: url)
    }
}
