//
//  AboutViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation

class AboutViewModel:
    ViewModel
<
    AboutViewState,
    AboutViewModel.ViewAction,
    AboutViewModel.Eff
>,
    AboutModuleInput
{
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        // Start listening IAPProvider
        reload()
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .demoBufferedTap:
            demoBufferedTap()
        case .demoNonBufferedTap:
            demoNonBufferedTap()
        }
    }
    
    private func demoBufferedTap() {
        onAction?(.openDemo(isBuffered: true))
    }
    
    private func demoNonBufferedTap() {
        onAction?(.openDemo(isBuffered: false))
    }
    
    private func reload() {
        let demoVideoURL = Bundle.main.url(forResource: "video_short", withExtension: "mp4")!
        let demoVideo = Video(url: demoVideoURL)
        
        publishState(
            AboutViewState(
                demos: [
                    AboutViewState.DemoItem(
                        video: demoVideo,
                        titleText: "Demo video with Buffered-mode of captioning",
                        subtitleText: "Generates transcription \"on the fly\" using custom audioMix with MTAudioProcessingTap which provides AVAudioPCMBuffer that can be added to current SFSpeechAudioBufferRecognitionRequest",
                        demoType: .buffered
                    ),
                    AboutViewState.DemoItem(
                        video: demoVideo,
                        titleText: "Demo video with fully prepared transcription",
                        subtitleText: "Generates full transcription before playing a video",
                        demoType: .nonBuffered
                    )
                ],
                isLoading: false
            )
        )
    }
    
    
    // MARK: - AboutModuleInput
    var onAction: ((AboutModuleAction) -> Void)?
}

extension AboutViewModel {
    /// Actions that could published from View
    enum ViewAction {
        case demoBufferedTap
        case demoNonBufferedTap
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
}
