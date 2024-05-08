//
//  EditorViewModel.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import Combine
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
        case playPauseTap
        case scrubStarted
        case scrubEnded(seekTime: TimeInterval)
        case captioningModeCurrentWordTap
        case captioningModeRegularTap
        case captioningModeHighlightedTap
        case closeTap
    }
    
    /// Effects that could be published from ViewModel
    enum Eff {
        // No effects
    }
    
    // EditorViewModel is the specific case, because of that becides simple ViewState (see base ViewModel),
    // we also publish player observable state to sync playback status and slider as well
    @Published
    private(set) var player: ObservablePlayer?
    private var selectedVideo: Video?
    private var transcriptionProvider: VideoTranscriptionProvider?
    private var isBufferedTrascriptionMode = true
    private let captioningDecorator = CaptioningDecorator()
    
    
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
        startPlayerObservation()
    }
    
    override func onViewWillDisappear() {
        super.onViewWillDisappear()
        
        stopPlayerObservation()
        pause()
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
        case .playPauseTap:
            playPause()
        case .scrubStarted:
            scrubStarted()
        case .scrubEnded(let seekTime):
            scrubEnded(seekTime: seekTime)
        case .captioningModeCurrentWordTap:
            captioningModeCurrentWord()
        case .captioningModeRegularTap:
            captioningModeRegular()
        case .captioningModeHighlightedTap:
            captioningModeHighlighted()
        case .closeTap:
            close()
        }
    }
    
    private func selectVideo() {
        onAction?(.selectVideo)
    }
    
    private func playPause() {
        if player?.timeControlStatus == .paused {
            play()
        } else {
            pause()
        }
    }
    
    private func play() {
        if isBufferedTrascriptionMode {
            transcriptionProvider?.startBufferedTranscriptioning()
        }
        player?.play()
    }
    
    private func pause() {
        if isBufferedTrascriptionMode {
            transcriptionProvider?.stopBufferedTranscriptioning()
        }
        player?.pause()
    }
    
    private func scrubStarted() {
        player?.scrubState = .scrubStarted
        if isBufferedTrascriptionMode {
            transcriptionProvider?.stopBufferedTranscriptioning()
        }
    }
    
    private func scrubEnded(seekTime: TimeInterval) {
        player?.scrubState = .scrubEnded(seekTime)
        captioningDecorator.reset()
        if isBufferedTrascriptionMode {
            captioningDecorator.setTranscription(nil)
            transcriptionProvider?.startBufferedTranscriptioning()
        }
        reload()
    }
    
    private func captioningModeCurrentWord() {
        captioningDecorator.setCaptioningMode(.currentWord)
        reload()
    }
    
    private func captioningModeRegular() {
        captioningDecorator.setCaptioningMode(.regular)
        reload()
    }
    
    private func captioningModeHighlighted() {
        captioningDecorator.setCaptioningMode(.highlighted)
        reload()
    }
    
    private func close() {
        onAction?(.close)
    }
    
    /// Each time you want, you can rebuild current view state publish it for view with "reload"
    private func reload() {
        // TODO: Detect all the permissions
        let state: EditorViewState.State
        if selectedVideo != nil {
            state = .editing
            captioningDecorator.rebuildCaptioningText()
        } else {
            state = .selecting
        }
        
        let isLoading = transcriptionProvider?.isFullTranscriptionInProgress ?? false
        
        publishState(
            EditorViewState(
                isLoading: isLoading,
                state: state,
                captioningAttributedText: captioningDecorator.captioningAttributedText,
                captioningMode: .fromDecoratorCaptioningMode(captioningDecorator.captioningMode),
                timeControlStatus: .fromAVPlayerTimeControlStatus(player?.timeControlStatus)
            )
        )
    }
    
    
    // MARK: - Player observation
    private var playerObservedTimePublisher: AnyCancellable?
    private var playerTimeControlStatusPublisher: AnyCancellable?
    
    private func startPlayerObservation() {
        stopPlayerObservation()
        if let player = player {
            player.startObservation()
            // Observing playback to make captioning accordingly to current playback time
            playerObservedTimePublisher = player.$observedTime
                .receive(on: DispatchQueue.main)//.global(qos: .background))
                .removeDuplicates()
                .sink { [weak self] value in
                    self?.captioningDecorator.moveCaptioningWindow(currentTime: value)
                    self?.reload()
                }
            // Observing control status for correct icon name play/pause
            playerTimeControlStatusPublisher = player.$timeControlStatus
                .receive(on: DispatchQueue.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    self?.reload()
                }
        }
    }
    
    private func stopPlayerObservation() {
        playerObservedTimePublisher?.cancel()
        playerTimeControlStatusPublisher?.cancel()
        player?.stopObservation()
    }
    
    private func preparePlayer() {
        if let video = selectedVideo {
            self.player = ObservablePlayer(asset: video.asset)
            startPlayerObservation()
            reload()
        }
    }
    
    
    // MARK: - Captioning text building (Could be moved to smth like CaptioningDecorator)
    
    
    
    // MARK: - EditorModuleInput
    var onAction: ((EditorModuleAction) -> Void)?
    
    func setVideo(_ video: Video) {
        stopPlayerObservation()
        pause()
           
        self.transcriptionProvider = VideoTranscriptionProvider(asset: video.asset)
        // Listening for buffered transcription
        transcriptionProvider?.onBufferedTranscriptionChanged = { [weak self] lastBufferedTranscription in
            self?.captioningDecorator.setTranscription(lastBufferedTranscription)
        }
        // There is 2 modes of transcriptions: Buffered (live mode) / Regular (full translation before editing)
        captioningDecorator.setIsTailWindowMode(isBufferedTrascriptionMode)
        if isBufferedTrascriptionMode {
            self.selectedVideo = video
            preparePlayer()
            // Buffered mode
            // In case of buffered mode we have to use audioMix with MTAudioProcessingTap in inputParameters
            // audioMix synced with the playback state and time to time give us AVAudioPCMBuffer
            // that could be added to SFSpeechAudioBufferRecognitionRequest.
            // In this case transcription segments don't contains timestamps and duration.
            // Because of that in buffered mode we only can show last captions in "live mode" like in "interviews"
            // This is experimental mode and added just to demonstrate it.
            // Seems like for our case it's better prepare captions before editing.
            player?.avPlayer.currentItem?.audioMix = transcriptionProvider?.tapAudioMix
        } else {
            // Otherwise generate full transcription before playing
            transcriptionProvider?.provideFullTranscription { [weak self] transcription in
                guard let self else { return }
                
#if DEBUG
                transcription?.segments.enumerated().forEach({
                    print("\($0): \($1.substring) [\($1.timestamp)..\($1.timestamp + $1.duration)]")
                })
#endif
                
                self.captioningDecorator.setTranscription(transcription)
                self.selectedVideo = video
                preparePlayer()
            }
            reload()
        }
    }
}
