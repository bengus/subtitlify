//
//  PermissionsView.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import PinLayout

final class PermissionsView: MvvmUIKitView
<
    PermissionsViewModel,
    PermissionsViewState,
    PermissionsViewModel.ViewAction,
    PermissionsViewModel.Eff
> {
    // MARK: - Subviews
    private lazy var centerWrapperView = UIView(frame: .zero)
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.bold(ofSize: 24)
        label.textColor = Design.Colors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.mediumText
        label.textColor = Design.Colors.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var askPermissionButton = Buttons.solidAccent(title: "Request")
    
    private lazy var loadingView = LoadingView(
        indicatorColor: Design.Colors.loadingIndicatorGrey,
        backdropColor: Design.Colors.loadingBackdropColor
    )
    
    
    // MARK: - Init
    override init(viewModel: PermissionsViewModel) {
        super.init(viewModel: viewModel)
        
        self.backgroundColor = Design.Colors.defaultBackground
        
        addSubview(centerWrapperView)
        centerWrapperView.addSubview(logoImageView)
        centerWrapperView.addSubview(titleLabel)
        centerWrapperView.addSubview(subtitleLabel)
        centerWrapperView.addSubview(askPermissionButton)
        addSubview(loadingView)
        
        askPermissionButton.addTarget(self, action: #selector(askPermissionButtonPressed), for: .touchUpInside)
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
        
        logoImageView.pin
            .top()
            .hCenter()
            .width(Design.Metrics.logoWidth)
            .height(Design.Metrics.logoWidth)
        
        titleLabel.pin
            .below(of: logoImageView)
            .marginTop(Design.Metrics.bigVerticalGap)
            .horizontally()
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel)
            .marginTop(Design.Metrics.smallVerticalGap)
            .horizontally(Design.Metrics.bigHorizontalGap)
            .sizeToFit(.width)
        
        askPermissionButton.pin
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
    private func askPermissionButtonPressed() {
        viewModel.sendViewAction(.askPermissionTap)
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: PermissionsViewState) {
        super.onState(state)
        
        if let imageName = state.imageName {
            logoImageView.image = UIImage(named: imageName)
        } else {
            logoImageView.image = nil
        }
        titleLabel.text = state.titleText
        subtitleLabel.text = state.subtitleText
        askPermissionButton.setTitle(state.buttonText, for: .normal)
        loadingView.setLoading(state.isLoading)
        
        setNeedsLayout()
    }
}

private extension Design.Metrics {
    static let logoWidth: CGFloat = 100
}
