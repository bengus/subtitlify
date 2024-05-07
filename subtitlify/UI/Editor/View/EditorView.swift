//
//  EditorView.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
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
        label.font = Design.Fonts.mediumText
        label.textColor = Design.Colors.primaryText
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingHead
        
        return label
    }()
    
    private lazy var subtitlesWrapperView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Design.Colors.Palette.white.withAlphaComponent(0.6)
        return view
    }()
    
    
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
        subtitlesWrapperView.addSubview(subtitlesLabel)
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
        playerView.pin.all()
        playerLayer.frame = playerView.bounds
        subtitlesWrapperView.pin
            .horizontally()
            .bottom()
        subtitlesLabel.pin
            .top()
            .horizontally(Design.Metrics.horizontalGap)
            .height(Design.Metrics.subtitlesHeight)
            .marginTop(Design.Metrics.verticalGap)
        subtitlesWrapperView.pin
            .height(subtitlesLabel.frame.maxY + Design.Metrics.verticalGap)
        
        return frame.size
    }
    
    
    // MARK: - Control's actions
    @objc
    private func selectButtonPressed() {
        viewModel.sendViewAction(.selectVideoTap)
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
        
        playerLayer.player = viewModel.player?.avPlayer
        subtitlesLabel.text = state.captioning
        
        setNeedsLayout()
    }
}

private extension Design.Metrics {
    static let subtitlesHeight: CGFloat = 120
}
