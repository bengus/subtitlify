//
//  ProjectCreateView.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import PinLayout

final class ProjectCreateView: MvvmUIKitView
<
    ProjectCreateViewModel,
    ProjectCreateViewState,
    ProjectCreateViewModel.ViewAction,
    ProjectCreateViewModel.Eff
> {
    // MARK: - Subviews
    private lazy var centerWrapperView = UIView(frame: .zero)
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.semibold(ofSize: 18)
        label.textColor = Design.Colors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Here could be more options to create a project.\nFor example, record button, some templates, or project name."
        return label
    }()
    
    private lazy var selectVideoButton = Buttons.solidAccent(title: "Select video")
    
    private lazy var loadingView = LoadingView(
        indicatorColor: Design.Colors.loadingIndicatorGrey,
        backdropColor: Design.Colors.loadingBackdropColor
    )
    
    
    // MARK: - Init
    override init(viewModel: ProjectCreateViewModel) {
        super.init(viewModel: viewModel)
        
        self.backgroundColor = Design.Colors.defaultBackground
        
        addSubview(centerWrapperView)
        centerWrapperView.addSubview(subtitleLabel)
        centerWrapperView.addSubview(selectVideoButton)
        addSubview(loadingView)
        
        selectVideoButton.addTarget(self, action: #selector(selectButtonPressed), for: .touchUpInside)
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
        centerWrapperView.pin.horizontally()
        
        subtitleLabel.pin
            .top()
            .horizontally(Design.Metrics.bigHorizontalGap)
            .sizeToFit(.width)
        
        selectVideoButton.pin
            .below(of: subtitleLabel)
            .marginTop(Design.Metrics.bigVerticalGap)
            .width(Design.Metrics.buttonWidth)
            .hCenter()
            .sizeToFit(.width)
        
        centerWrapperView.pin
            .wrapContent(.vertically)
            .vCenter()
        
        loadingView.pin.all()
        
        return frame.size
    }
    
    
    // MARK: - Control's actions
    @objc
    private func selectButtonPressed() {
        viewModel.sendViewAction(.selectVideoTap)
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: ProjectCreateViewState) {
        super.onState(state)
        
        loadingView.setLoading(state.isLoading)
        
        setNeedsLayout()
    }
}
