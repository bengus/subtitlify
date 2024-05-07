//
//  EditorViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import Speech

class EditorViewModel:
    ViewModel
<
    EditorViewState,
    EditorViewModel.ViewAction,
    EditorViewModel.Eff
>,
    EditorModuleInput
{
    /// Actions that could published from View
    enum ViewAction {
        case selectVideoTap
        case closeTap
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        case registerForRemoteNotifications
    }
    
    // EditorViewModel is the specific case, because of that becides simple ViewState (see base ViewModel),
    // we also publish player observable state to sync playback status and slider as well
    @Published
    private(set) var player: ObservablePlayer?
    private var selectedVideo: Video?
    private var captioning: String?
    private var speechRecognitionProvider: VideoSpeechRecognitionProvider?
    
    
    // MARK: - Init
    override init(initialState: EditorViewState) {
        super.init(initialState: initialState)
    }
    
    deinit {
#if DEBUG
        print("EditorViewModel deinit")
#endif
    }
    
    
    // MARK: - Lifecycle
    override func onViewWillAppear() {
        super.onViewWillAppear()
        reload()
    }
    
    override func onViewDidAppear() {
        super.onViewDidAppear()
        player?.startPlaybackObservation()
    }
    
    override func onViewWillDisappear() {
        super.onViewWillDisappear()
        player?.stopPlaybackObservation()
        speechRecognitionProvider?.stop()
        player?.pause()
    }
    
    override func onViewDidFirstAppear() {
        super.onViewDidFirstAppear()
        
        SFSpeechRecognizer.requestAuthorization { status in
            assert(status == .authorized)
            DispatchQueue.main.async {
#if DEBUG
                print("SFSpeechRecognizer permission granted")
#endif
            }
        }
    }
    
    
    // MARK: - ViewActions
    override func onViewAction(_ action: ViewAction) {
        switch action {
        case .selectVideoTap:
            selectVideo()
        case .closeTap:
            close()
        }
    }
    
    private func selectVideo() {
        onAction?(.selectVideo)
    }
    
    private func close() {
        onAction?(.close)
    }
    
    private func reload() {
        // TODO: Detect all the permissions
        let state: EditorViewState.State
        if selectedVideo != nil {
            state = .editing
        } else {
            state = .selecting
        }
        
        publishState(
            EditorViewState(
                isLoading: false,
                state: state,
                captioning: self.captioning
            )
        )
    }
    
    
    // MARK: - EditorModuleInput
    var onAction: ((EditorModuleAction) -> Void)?
    
    func setVideo(_ video: Video) {
        speechRecognitionProvider?.stop()
        player?.stopPlaybackObservation()
        player?.pause()
        
        self.selectedVideo = video
        self.player = ObservablePlayer(asset: video.asset)
        player?.startPlaybackObservation()
        reload()
           
        // Create RecognitionProvider
        self.speechRecognitionProvider = VideoSpeechRecognitionProvider(asset: video.asset)
        speechRecognitionProvider?.onCaptioningChanged = { [weak self] captioning in
            self?.captioning = captioning
            self?.reload()
        }
        // Use audioMix from VideoSpeechRecognitionProvider
        player?.avPlayer.currentItem?.audioMix = speechRecognitionProvider?.audioMix
        speechRecognitionProvider?.start()
        player?.play()
    }
}
