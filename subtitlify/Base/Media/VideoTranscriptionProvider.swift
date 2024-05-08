//
//  VideoTranscriptionProvider.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import Speech

public final class VideoTranscriptionProvider: NSObject,
                                               MYAudioTabProcessorDelegate
{
    private let asset: AVURLAsset
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var bufferedRecognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var bufferedRecognitionTask: SFSpeechRecognitionTask?
    private var audioTapProcessor: MYAudioTapProcessor?
    public var tapAudioMix: AVAudioMix? {
        return audioTapProcessor?.audioMix
    }
    
    public var onBufferedTranscriptionChanged: ((SFTranscription?) -> Void)?
    private var lastBufferedTranscription: SFTranscription?
    
    
    
    // MARK: - Init
    public init?(asset: AVURLAsset) {
        self.asset = asset
        // Tap
        // Slightly modified audio tap sample https://developer.apple.com/library/ios/samplecode/AudioTapProcessor/Introduction/Intro.html#//apple_ref/doc/uid/DTS40012324-Intro-DontLinkElementID_2
        // Takes AVAssetTrack and produces AVAudioPCMBuffer
        // great thanks to AVFoundation, CoreFoundation and SpeechKit engineers for helping to figure this out!
        // especially to Eric Lee for explaining how to convert AudioBufferList -> AVAudioPCMBuffer
        guard
            let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first,
            let tap = MYAudioTapProcessor(audioAssetTrack: audioTrack) else
        { return nil }
        self.audioTapProcessor = tap
        
        super.init()
        
        tap.delegate = self
    }
    
    deinit {
#if DEBUG
        print("VideoTranscriptionProvider deinit")
#endif
    }
    
    
    // MARK: - Buffered transcription
    public func startBufferedTranscriptioning() {
        audioTapProcessor?.delegate = self
        startBufferedRecognitionTask()
    }
    
    public func stopBufferedTranscriptioning() {
        bufferedRecognitionTask?.cancel()
        audioTapProcessor?.delegate = nil
        self.bufferedRecognitionRequest = nil
        self.bufferedRecognitionTask = nil
    }
    
    private func startBufferedRecognitionTask() {
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        if speechRecognizer.supportsOnDeviceRecognition {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        speechRecognizer.defaultTaskHint = .dictation
        self.bufferedRecognitionRequest = recognitionRequest
        bufferedRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            
            if  let result = result {
                Task { @MainActor [weak self] in
                    self?.lastBufferedTranscription = result.bestTranscription
                    self?.onBufferedTranscriptionChanged?(result.bestTranscription)
                }
            }
            
            // once in about every minute recognition task finishes so we need to set up a new one to continue recognition
            if result?.isFinal == true {
                self.bufferedRecognitionRequest = nil
                self.bufferedRecognitionTask = nil
                self.startBufferedRecognitionTask()
            }
            
            if error != nil {
                self.stopBufferedTranscriptioning()
            }
        }
        self.bufferedRecognitionRequest = recognitionRequest
    }
    
    
    // MARK: - Full transcription
    private var fullRecognitionTask: SFSpeechRecognitionTask?
    
    public var isFullTranscriptionInProgress: Bool {
        return fullRecognitionTask != nil
    }
    
    func provideFullTranscription(completion: @escaping (SFTranscription?) -> Void) {
        let recognitionRequest = SFSpeechURLRecognitionRequest(url: asset.url)
        recognitionRequest.shouldReportPartialResults = false
        if speechRecognizer.supportsOnDeviceRecognition {
            recognitionRequest.requiresOnDeviceRecognition = true
        }
        speechRecognizer.defaultTaskHint = .dictation
        fullRecognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            guard let self else { return }
            
            if
                let result = result,
                result.isFinal
            {
                self.fullRecognitionTask = nil
                completion(result.bestTranscription)
            }
            
            if error != nil {
                self.fullRecognitionTask = nil
                completion(nil)
            }
        }
    }
    
    
    // MARK: - MYAudioTabProcessorDelegate
    public func audioTabProcessor(_ audioTabProcessor: MYAudioTapProcessor!, didReceive buffer: AVAudioPCMBuffer!) {
        // getting audio buffer back from the tap and feeding into speech recognizer
        bufferedRecognitionRequest?.append(buffer)
    }
}
