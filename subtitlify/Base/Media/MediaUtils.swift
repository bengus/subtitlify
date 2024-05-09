//
//  MediaUtils.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import UIKit
import Photos
import AVFoundation

public enum MediaError: Error {
    case encodingVideoToMp4Failed(reason: Error?)
}

public enum MediaUtils {
    public static let mediaFileTypeMp4 = "mp4"
    
    public static func getDocumentsDirectoryUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public static func getTempDirectoryUrl() -> URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    public static func getUniqueMediaFileName(withExt fileExtension: String) -> String {
        return "\(UUID().uuidString).\(fileExtension)"
    }
    
    public static func getDocumentsFileUrl(forFileName fileName: String) -> URL {
        return getDocumentsDirectoryUrl().appendingPathComponent(fileName)
    }
    
    public static func getTempFileUrl(forFileName fileName: String) -> URL {
        return getTempDirectoryUrl().appendingPathComponent(fileName)
    }
    
    public static func movedVideoToDocumentsDirectory(
        _ sourceVideo: Video,
        newFileName: String
    ) -> Video {
        let newVideoUrl = MediaUtils.getDocumentsFileUrl(forFileName: newFileName)
        // TODO error handling
        try! FileManager.default.moveItem(
            at: sourceVideo.url,
            to: newVideoUrl
        )
        
        return Video(url: newVideoUrl)
    }
    
    public static func previewImageFromVideo(url: URL) -> UIImage? {
        let request = URLRequest(url: url)
        let cache = URLCache.shared

        if
            let cachedResponse = cache.cachedResponse(for: request),
            let image = UIImage(data: cachedResponse.data)
        {
            return image
        }

        let asset = AVAsset(url: url)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 250, height: CGFloat.greatestFiniteMagnitude)

        var time = asset.duration
        time.value = min(time.value, 2000)

        var image: UIImage?

        do {
            let cgImage = try generator.copyCGImage(at: time, actualTime: nil)
            image = UIImage(cgImage: cgImage)
        } catch {
            return nil
        }

        if
            let image = image,
            let data = image.pngData(),
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        {
            let cachedResponse = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedResponse, for: request)
        }

        return image
    }
    
    public static func encodeVideoToMp4(videoUrl: URL) async throws -> Video {
        let savingFilePath = MediaUtils.getUniqueMediaFileName(withExt: MediaUtils.mediaFileTypeMp4)
        let savingUrl = MediaUtils.getTempFileUrl(forFileName: savingFilePath)
        let sourceAsset = AVURLAsset(url: videoUrl)
        
        // Export
        guard let exportSession = AVAssetExportSession(
            asset: sourceAsset,
            presetName: AVAssetExportPresetPassthrough
        ) else {
            throw MediaError.encodingVideoToMp4Failed(reason: nil)
        }
        exportSession.timeRange = CMTimeRange(start: CMTime(seconds: 0, preferredTimescale: 1), duration: sourceAsset.duration)
        exportSession.outputURL = savingUrl
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        
        await exportSession.export()
        switch exportSession.status {
        case .completed:
            let encodedVideo = Video(url: savingUrl)
            return encodedVideo
        default:
            throw MediaError.encodingVideoToMp4Failed(reason: exportSession.error)
        }
    }
    
    public static func requestPhotoLibraryAuthorization(
        completion: @escaping (Bool) -> Void
    ) {
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            DispatchQueue.main.async {
                completion(true)
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status == .authorized)
                }
            }
        }
    }
}
