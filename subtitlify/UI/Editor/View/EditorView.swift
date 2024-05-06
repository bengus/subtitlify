//
//  EditorView.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class EditorView: MvvmUIKitView
<
    EditorViewModel,
    EditorViewState,
    EditorViewModel.ViewAction,
    EditorViewModel.Eff
> {
    // MARK: - Subviews
    
    
    // MARK: - Init
    override init(viewModel: EditorViewModel) {
        super.init(viewModel: viewModel)
        self.backgroundColor = Design.Colors.defaultBackground
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
        return frame.size
    }
    
    
    // MARK: - Control's actions
//    @objc
//    private func someButtonPressed() {
//        viewModel.sendViewAction(.someTap)
//    }
    
    
    // MARK: - State and effects
    override func onState(_ state: EditorViewState) {
        super.onState(state)
        
        setNeedsLayout()
    }
}
