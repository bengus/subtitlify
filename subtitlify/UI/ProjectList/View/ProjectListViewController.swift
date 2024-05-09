//
//  ProjectListViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit

final class ProjectListViewController: MvvmUIKitViewController
<
    ProjectListView,
    ProjectListViewModel,
    ProjectListViewState,
    ProjectListViewModel.ViewAction,
    ProjectListViewModel.Eff
>
{
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Projects"
    }
}
