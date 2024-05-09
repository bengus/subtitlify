//
//  PermissionsViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

final class PermissionsViewController: MvvmUIKitViewController
<
    PermissionsView,
    PermissionsViewModel,
    PermissionsViewState,
    PermissionsViewModel.ViewAction,
    PermissionsViewModel.Eff
>
{
    private lazy var closeButton = Buttons.navbarImageButtonItem(
        image: UIImage(named: "modal_close")!.withRenderingMode(.alwaysTemplate),
        target: self,
        action: #selector(closeTapped(sender:))
    )
    
    
    // MARK: - Init
    override init(
        viewModel: PermissionsViewModel,
        viewFactory: @escaping (PermissionsViewModel) -> PermissionsView
    ) {
        super.init(
            viewModel: viewModel,
            viewFactory: viewFactory
        )
        self.hidesBottomBarWhenPushed = true
    }
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Permissions require"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isRootInNavigationController && presentingViewController != nil {
            navigationItem.rightBarButtonItem = closeButton
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: PermissionsViewState) {
        super.onState(state)
        closeButton.isEnabled = !state.isLoading
    }
    
    
    // MARK: - Control's actions
    @objc
    private func closeTapped(sender: UIButton) {
        viewModel.sendViewAction(.closeTap)
    }
}
