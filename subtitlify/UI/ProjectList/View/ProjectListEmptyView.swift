//
//  ProjectListEmptyView.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class ProjectListEmptyView: UIView {
    // MARK: - Subviews
    
    private lazy var centerWrapperView = UIView(frame: .zero)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.bold(ofSize: 24)
        label.textColor = Design.Colors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "No projects yet"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.defaultText
        label.textColor = Design.Colors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Tap to start your first project"
        return label
    }()

    private lazy var createProjectButton = Buttons.solidAccent(title: "Create")
    
    var onCreateProjectTap: (() -> Void)?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(centerWrapperView)
        centerWrapperView.addSubview(titleLabel)
        centerWrapperView.addSubview(subtitleLabel)
        centerWrapperView.addSubview(createProjectButton)
        
        createProjectButton.addTarget(self, action: #selector(createProjectButtonPressed), for: .touchUpInside)
    }
    
    @available(*, unavailable, message: "Use another init()")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        titleLabel.pin
            .top()
            .horizontally()
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel)
            .marginTop(Design.Metrics.verticalGap)
            .horizontally()
            .sizeToFit(.width)
        
        createProjectButton.pin
            .below(of: subtitleLabel)
            .marginTop(Design.Metrics.bigVerticalGap)
            .width(Design.Metrics.buttonWidth)
            .hCenter()
            .sizeToFit(.width)
        
        centerWrapperView.pin
            .wrapContent()
            .vCenter()
        
        return frame.size
    }
    
    
    // MARK: - Control's actions
    @objc
    private func createProjectButtonPressed() {
        onCreateProjectTap?()
    }
}
