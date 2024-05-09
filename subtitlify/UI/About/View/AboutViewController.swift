//
//  AboutViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

final class AboutViewController: MvvmUIKitViewController
<
    AboutView,
    AboutViewModel,
    AboutViewState,
    AboutViewModel.ViewAction,
    AboutViewModel.Eff
>
{
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About"
    }
}
