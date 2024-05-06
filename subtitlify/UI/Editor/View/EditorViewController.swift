//
//  EditorViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class EditorViewController: MvvmUIKitViewController
<
    EditorView,
    EditorViewModel,
    EditorViewState,
    EditorViewModel.ViewAction,
    EditorViewModel.Eff
>
{
    private lazy var closeButton = UIBarButtonItem(
        image: UIImage(named: "modal_close")!.withRenderingMode(.alwaysTemplate),
        style: .plain,
        target: self,
        action: #selector(closeTapped(sender:))
    )
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Editor"
        if isRootInNavigationController && presentingViewController != nil {
            closeButton.tintColor = Design.Colors.navBarText
            navigationItem.rightBarButtonItem = closeButton
        }
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: EditorViewState) {
        super.onState(state)
        closeButton.isEnabled = !state.isLoading
    }
    
    
    // MARK: - Control's actions
    @objc
    private func closeTapped(sender: UIButton) {
        viewModel.sendViewAction(.closeTap)
    }
}
