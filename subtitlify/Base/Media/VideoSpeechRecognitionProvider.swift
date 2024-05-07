//
//  VideoSpeechRecognitionProvider.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import Speech

public final class VideoSpeechRecognitionProvider: NSObject,
                                                   MYAudioTabProcessorDelegate
{
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private let audioEngine = AVAudioEngine()
    private var tap: MYAudioTapProcessor?
    
    public var onCaptioningChanged: ((String?) -> Void)?
    public var audioMix: AVAudioMix? {
        return tap?.audioMix
    }
    
    
    // MARK: - Init
    public init?(asset: AVURLAsset) {
        // Tap
        // Slightly modified audio tap sample https://developer.apple.com/library/ios/samplecode/AudioTapProcessor/Introduction/Intro.html#//apple_ref/doc/uid/DTS40012324-Intro-DontLinkElementID_2
        // Takes AVAssetTrack and produces AVAudioPCMBuffer
        // great thanks to AVFoundation, CoreFoundation and SpeechKit engineers for helping to figure this out!
        // especially to Eric Lee for explaining how to convert AudioBufferList -> AVAudioPCMBuffer
        guard
            let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first,
            let tap = MYAudioTapProcessor(audioAssetTrack: audioTrack) else
        { return nil }
        self.tap = tap
        
        super.init()
        
        tap.delegate = self
    }
    
    deinit {
#if DEBUG
        print("VideoSpeechRecognitionProvider deinit")
#endif
    }
    
    
    // MARK: - RecognitionProvider
    public func start() {
        tap?.delegate = self
        startRecognitionTask()
    }
    
    public func stop() {
        recognitionTask?.cancel()
        tap?.delegate = nil
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
    
    private func startRecognitionTask() {
        // Recognition request
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        if speechRecognizer.supportsOnDeviceRecognition {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        self.recognitionRequest = recognitionRequest
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            
            self.onCaptioningChanged?(result?.bestTranscription.formattedString)
            
            // once in about every minute recognition task finishes so we need to set up a new one to continue recognition
            if result?.isFinal == true {
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.startRecognitionTask()
            }
            
            if error != nil {
                // TODO: error handling
                self.stop()
            }
        }
        self.recognitionRequest = recognitionRequest
    }
    
    
    // MARK: - MYAudioTabProcessorDelegate
    public func audioTabProcessor(_ audioTabProcessor: MYAudioTapProcessor!, didReceive buffer: AVAudioPCMBuffer!) {
        // getting audio buffer back from the tap and feeding into speech recognizer
        recognitionRequest?.append(buffer)
    }
}
