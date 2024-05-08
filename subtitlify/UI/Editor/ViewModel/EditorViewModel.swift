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
    
    private let context: EditorContext
    private let isBufferedTrascriptionMode: Bool
    private let selectedVideo: Video
    private let transcriptionProvider: VideoTranscriptionProvider?
    private let captioningDecorator = CaptioningDecorator()
    
    // EditorViewModel is the specific case, because of that becides simple ViewState (see base ViewModel),
    // we also expose player observable state to sync playback status and slider as well.
    let player: ObservablePlayer
    
    
    // MARK: - Init
    init(
        initialState: EditorViewState,
        context: EditorContext
    ) {
        self.context = context
        switch context {
        case .demo(let isBuffered):
            self.isBufferedTrascriptionMode = isBuffered
            let demoVideoURL = Bundle.main.url(forResource: "video_short", withExtension: "mp4")!
            self.selectedVideo = Video(url: demoVideoURL)
        case .project(let project):
            self.isBufferedTrascriptionMode = false
            self.selectedVideo = Video(url: project.videoUrl)
        }
        self.player = ObservablePlayer(
            asset: selectedVideo.asset,
            periodicTimeObservationInterval: 0.1
        )
        self.transcriptionProvider = VideoTranscriptionProvider(asset: selectedVideo.asset)
        
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
    
    override func onViewDidFirstAppear() {
        super.onViewDidFirstAppear()
        
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            assert(status == .authorized)
            DispatchQueue.main.async { [weak self] in
#if DEBUG
                print("SFSpeechRecognizer permission granted")
#endif
                self?.prepareTranscription()
            }
        }
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
        if player.timeControlStatus == .paused {
            play()
        } else {
            pause()
        }
    }
    
    private func play() {
        if player.observedTime == selectedVideo.durationSeconds {
            player.scrubState = .scrubEnded(0)
        }
        if isBufferedTrascriptionMode {
            transcriptionProvider?.startBufferedTranscriptioning()
        }
        player.play()
    }
    
    private func pause() {
        if isBufferedTrascriptionMode {
            transcriptionProvider?.stopBufferedTranscriptioning()
        }
        player.pause()
    }
    
    private func scrubStarted() {
        player.scrubState = .scrubStarted
        if isBufferedTrascriptionMode {
            transcriptionProvider?.stopBufferedTranscriptioning()
        }
    }
    
    private func scrubEnded(seekTime: TimeInterval) {
        player.scrubState = .scrubEnded(seekTime)
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
        } else {
            state = .selecting
        }
        
        let isLoading = transcriptionProvider?.isFullTranscriptionInProgress ?? false
        
        publishState(
            EditorViewState(
                isLoading: isLoading,
                state: state,
                captioningAttributedText: captioningDecorator.getCaptioningAttributedText(),
                captioningMode: .fromDecoratorCaptioningMode(captioningDecorator.captioningMode),
                timeControlStatus: .fromAVPlayerTimeControlStatus(player.timeControlStatus)
            )
        )
    }
    
    
    // MARK: - Player observation
    private var playerObservedTimePublisher: AnyCancellable?
    private var playerTimeControlStatusPublisher: AnyCancellable?
    
    private func startPlayerObservation() {
        stopPlayerObservation()
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
    
    private func stopPlayerObservation() {
        playerObservedTimePublisher?.cancel()
        playerTimeControlStatusPublisher?.cancel()
        player.stopObservation()
    }
    
    private func prepareTranscription() {
        // Listening for buffered transcription
        transcriptionProvider?.onBufferedTranscriptionChanged = { [weak self] lastBufferedTranscription in
            self?.captioningDecorator.setTranscription(lastBufferedTranscription)
        }
        // There is 2 modes of transcriptions: Buffered (live mode) / Regular (full translation before editing)
        captioningDecorator.setIsTailWindowMode(isBufferedTrascriptionMode)
        if isBufferedTrascriptionMode {
            // Buffered mode
            // In case of buffered mode we have to use audioMix with MTAudioProcessingTap in inputParameters
            // audioMix synced with the playback state and time to time give us AVAudioPCMBuffer
            // that could be added to SFSpeechAudioBufferRecognitionRequest.
            // In this case transcription segments don't contains timestamps and duration.
            // Because of that in buffered mode we only can show last captions in "live mode" like in "interviews"
            // This is experimental mode and added just to demonstrate it.
            // Seems like for our case it's better prepare captions before editing.
            player.avPlayer.currentItem?.audioMix = transcriptionProvider?.tapAudioMix
        } else {
            // Otherwise generate full transcription before playing
            transcriptionProvider?.provideFullTranscription { [weak self] transcription in
                self?.captioningDecorator.setTranscription(transcription)
                self?.reload()
            }
            reload()
        }
    }
    
    
    
    // MARK: - EditorModuleInput
    var onAction: ((EditorModuleAction) -> Void)?
}
