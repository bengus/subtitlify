//
//  EditorView.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import PinLayout

final class EditorView: MvvmUIKitView
<
    EditorViewModel,
    EditorViewState,
    EditorViewModel.ViewAction,
    EditorViewModel.Eff
> {
    // MARK: - Subviews
    private lazy var selectingWrapperView = UIView(frame: .zero)
    private lazy var editingWrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Design.Colors.playbackBackround
        return view
    }()
    private lazy var permissionWrapperView = UIView(frame: .zero)
    
    private lazy var selectVideoButton = Buttons.solidAccent(title: "Select video")

    private lazy var playerLayer = AVPlayerLayer()
    private lazy var playerView: UIView = {
        let view = UIView(frame: .zero)
        view.layer.insertSublayer(playerLayer, at: 0)
        return view
    }()
    
    private lazy var subtitlesLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.semibold(ofSize: 18)
        label.textColor = Design.Colors.lightText
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var subtitlesWrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Design.Colors.Palette.pianoBlack.withAlphaComponent(0.6)
        return view
    }()
    
    private lazy var controlsWrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Design.Colors.playbackBackround
        return view
    }()
    
    private lazy var playPauseButton = Buttons.image(
        image: UIImage(named: "44_play_solid"),
        backgroundColor: Design.Colors.playbackBackround
    )
    
    private lazy var progressSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = Design.Colors.accent
        slider.maximumTrackTintColor = Design.Colors.defaultBackground
        slider.isContinuous = true
        return slider
    }()
    
    private lazy var modeWordByWordButton = Buttons.solidSecondary(title: "word")
    private lazy var modeRegularButton = Buttons.solidSecondary(title: "regular")
    private lazy var modeHighlightedButton = Buttons.solidSecondary(title: "highlighted")
    
    private lazy var loadingView = LoadingView(
        indicatorColor: Design.Colors.loadingIndicatorWhite,
        backdropColor: Design.Colors.loadingBackdropColor
    )
    
    
    // MARK: - Init
    override init(viewModel: EditorViewModel) {
        super.init(viewModel: viewModel)
        
        self.backgroundColor = Design.Colors.defaultBackground
        
        addSubview(selectingWrapperView)
        addSubview(editingWrapperView)
        addSubview(permissionWrapperView)
        selectingWrapperView.isHidden = true
        editingWrapperView.isHidden = true
        permissionWrapperView.isHidden = true
        
        selectingWrapperView.addSubview(selectVideoButton)
        selectVideoButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
        
        editingWrapperView.addSubview(playerView)
        editingWrapperView.addSubview(subtitlesWrapperView)
        editingWrapperView.addSubview(controlsWrapperView)
            
        subtitlesWrapperView.addSubview(subtitlesLabel)
        
        controlsWrapperView.addSubview(playPauseButton)
        controlsWrapperView.addSubview(progressSlider)
        controlsWrapperView.addSubview(modeWordByWordButton)
        controlsWrapperView.addSubview(modeRegularButton)
        controlsWrapperView.addSubview(modeHighlightedButton)
        
        addSubview(loadingView)
        
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPressed), for: .touchUpInside)
        progressSlider.addTarget(self, action: #selector(sliderValueChanged(sender:event:)), for: .valueChanged)
        modeWordByWordButton.addTarget(self, action: #selector(modeWordByWordButtonPressed), for: .touchUpInside)
        modeRegularButton.addTarget(self, action: #selector(modeRegularButtonPressed), for: .touchUpInside)
        modeHighlightedButton.addTarget(self, action: #selector(modeHighlightedButtonPressed), for: .touchUpInside)
        subtitlesWrapperView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleSubtitlesPan)))
        
        // Observing $player becides normal UI State
        startPlayerObservation()
    }
    
    deinit {
        stopPlayerObservation()
    }
    
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.pin.width(size.width)
        return layout()
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setNeedsLayout()
    }
    
    
    // MARK: - Layout
    @discardableResult
    private func layout() -> CGSize {
        // permission
        permissionWrapperView.pin.all()
        
        // selecting
        selectingWrapperView.pin.all()
        selectVideoButton.pin
            .apply({
                if Design.isIpad {
                    $0.width(Design.Metrics.buttonWidthIpad)
                    $0.hCenter()
                } else {
                    $0.horizontally(Design.Metrics.horizontalGap)
                }
            })
            .sizeToFit(.width)
            .vCenter()
        
        // editing
        editingWrapperView.pin.all()
        
        // controls
        controlsWrapperView.pin
            .horizontally()
            .bottom()
        playPauseButton.pin
            .top(Design.Metrics.smallVerticalGap)
            .left(Design.Metrics.smallHorizontalGap)
            .size(Design.Metrics.playPauseHeight)
        progressSlider.pin
            .after(of: playPauseButton)
            .right(Design.Metrics.smallHorizontalGap)
            .height(Design.Metrics.sliderHeight)
            .vCenter(to: playPauseButton.edge.vCenter)
        let buttonWidth: CGFloat = (controlsWrapperView.frame.width - Design.Metrics.horizontalGap * CGFloat(2) - Design.Metrics.modeButtonsGap * CGFloat(2)) / CGFloat(3)
        modeWordByWordButton.pin
            .below(of: playPauseButton)
            .left(Design.Metrics.horizontalGap)
            .width(buttonWidth)
            .sizeToFit(.width)
        modeRegularButton.pin
            .below(of: playPauseButton)
            .after(of: modeWordByWordButton)
            .marginLeft(Design.Metrics.modeButtonsGap)
            .width(buttonWidth)
            .sizeToFit(.width)
        modeHighlightedButton.pin
            .below(of: playPauseButton)
            .after(of: modeRegularButton)
            .marginLeft(Design.Metrics.modeButtonsGap)
            .width(buttonWidth)
            .sizeToFit(.width)
        controlsWrapperView.pin
            .height(modeWordByWordButton.frame.maxY + Design.Metrics.verticalGap + pin.safeArea.bottom)
        
        // subtitles
        if let overridenSubtitlesOrigin {
            // following to overriden origin, but keep our width
            subtitlesWrapperView.pin
                .top(overridenSubtitlesOrigin.y)
                .left(overridenSubtitlesOrigin.x)
                .width(editingWrapperView.frame.width)
        } else {
            subtitlesWrapperView.pin
                .horizontally()
                .above(of: controlsWrapperView)
        }
        subtitlesLabel.pin
            .top()
            .horizontally(Design.Metrics.horizontalGap)
            .height(Design.Metrics.subtitlesHeight)
            .marginTop(Design.Metrics.verticalGap)
        subtitlesWrapperView.pin
            .height(subtitlesLabel.frame.maxY + Design.Metrics.verticalGap)
        
        playerView.pin
            .top()
            .horizontally()
            .above(of: controlsWrapperView)
        playerLayer.frame = playerView.bounds
        
        loadingView.pin.all()
        
        return frame.size
    }
    
    
    // MARK: - Control's actions
    @objc
    private func selectButtonPressed() {
        viewModel.sendViewAction(.selectVideoTap)
    }
    
    @objc
    private func playPauseButtonPressed() {
        viewModel.sendViewAction(.playPauseTap)
    }
    
    @objc
    private func sliderValueChanged(sender: UISlider, event: UIEvent) {
        if  let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                viewModel.sendViewAction(.scrubStarted)
            case .ended:
                viewModel.sendViewAction(.scrubEnded(seekTime: TimeInterval(sender.value)))
            default:
                break
            }
        }
        
    }
    
    @objc
    private func modeWordByWordButtonPressed() {
        viewModel.sendViewAction(.captioningModeCurrentWordTap)
    }
    
    @objc
    private func modeRegularButtonPressed() {
        viewModel.sendViewAction(.captioningModeRegularTap)
    }
    
    @objc
    private func modeHighlightedButtonPressed() {
        viewModel.sendViewAction(.captioningModeHighlightedTap)
    }
    
    // Didn't store it in ViewModel or in layer above because of demo
    private var overridenSubtitlesOrigin: CGPoint?
    
    @objc
    private func handleSubtitlesPan(_ gesture: UIPanGestureRecognizer) {
        if let draggingView = gesture.view {
            let point = gesture.translation(in: editingWrapperView)
            draggingView.center = CGPoint(
                x: draggingView.center.x + point.x,
                y: draggingView.center.y + point.y
            )
            overridenSubtitlesOrigin = draggingView.frame.origin
            gesture.setTranslation(.zero, in: editingWrapperView)
            switch gesture.state {
            case .began:
                draggingView.layer.borderWidth = 1
                draggingView.layer.borderColor = Design.Colors.accent.cgColor
            case .cancelled, .ended, .failed:
                draggingView.layer.borderWidth = 0
                draggingView.layer.borderColor = nil
            case .possible:
                break
            case .changed:
                break
            @unknown default:
                break
            }
        }
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: EditorViewState) {
        super.onState(state)
        
        switch state.state {
        case .permissionRequired where permissionWrapperView.isHidden:
            selectingWrapperView.isHidden = true
            editingWrapperView.isHidden = true
            permissionWrapperView.isHidden = false
        case .selecting where selectingWrapperView.isHidden:
            selectingWrapperView.isHidden = false
            editingWrapperView.isHidden = true
            permissionWrapperView.isHidden = true
        case .editing where editingWrapperView.isHidden:
            selectingWrapperView.isHidden = true
            editingWrapperView.isHidden = false
            permissionWrapperView.isHidden = true
        default:
            break
        }
        
        subtitlesLabel.attributedText = state.captioningAttributedText
        loadingView.setLoading(state.isLoading)
        switch state.timeControlStatus {
        case .paused:
            playPauseButton.setImage(UIImage(named: "44_play_solid"), for: .normal)
        case .playing:
            playPauseButton.setImage(UIImage(named: "44_pause_solid"), for: .normal)
        case .unknown:
            playPauseButton.setImage(nil, for: .normal)
        }
        
        switch state.captioningMode {
        case .currentWord:
            modeWordByWordButton.backgroundColor = Design.Colors.accent
            modeWordByWordButton.titleLabel?.textColor = Design.Colors.lightText
            modeRegularButton.backgroundColor = Design.Colors.info
            modeRegularButton.titleLabel?.textColor = Design.Colors.primaryText
            modeHighlightedButton.backgroundColor = Design.Colors.info
            modeHighlightedButton.titleLabel?.textColor = Design.Colors.primaryText
        case .regular:
            modeWordByWordButton.backgroundColor = Design.Colors.info
            modeWordByWordButton.titleLabel?.textColor = Design.Colors.primaryText
            modeRegularButton.backgroundColor = Design.Colors.accent
            modeRegularButton.titleLabel?.textColor = Design.Colors.lightText
            modeHighlightedButton.backgroundColor = Design.Colors.info
            modeHighlightedButton.titleLabel?.textColor = Design.Colors.primaryText
        case .highlighted:
            modeWordByWordButton.backgroundColor = Design.Colors.info
            modeWordByWordButton.titleLabel?.textColor = Design.Colors.primaryText
            modeRegularButton.backgroundColor = Design.Colors.info
            modeRegularButton.titleLabel?.textColor = Design.Colors.primaryText
            modeHighlightedButton.backgroundColor = Design.Colors.accent
            modeHighlightedButton.titleLabel?.textColor = Design.Colors.lightText
        }
        
        setNeedsLayout()
    }
    
    
    // MARK: - Player observation
    private var playerDisplayTimePublisher: AnyCancellable?
    
    private func startPlayerObservation() {
        stopPlayerObservation()
        
        let player = viewModel.player
        playerLayer.player = player.avPlayer
        progressSlider.maximumValue = Float(player.itemDuration)
        progressSlider.minimumValue = 0
        progressSlider.value = 0
        
        playerDisplayTimePublisher = player.$displayTime
            .receive(on: DispatchQueue.main)
            .throttle(for: .seconds(0.5), scheduler: DispatchQueue.main, latest: true)
            .sink { [weak self] value in
                self?.progressSlider.maximumValue = Float(player.itemDuration)
                self?.progressSlider.value = Float(value)
            }
    }
    
    private func stopPlayerObservation() {
        playerDisplayTimePublisher?.cancel()
    }
}

private extension Design.Metrics {
    static let subtitlesHeight: CGFloat = 120
    static let playPauseHeight: CGFloat = 44
    static let sliderHeight: CGFloat = 20
    static let modeButtonsGap: CGFloat = 4
}
