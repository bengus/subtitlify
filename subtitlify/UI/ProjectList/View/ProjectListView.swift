//
//  ProjectListView.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class ProjectListView: MvvmUIKitView
<
    ProjectListViewModel,
    ProjectListViewState,
    ProjectListViewModel.ViewAction,
    ProjectListViewModel.Eff
>,
    UITableViewDataSource,
    UITableViewDelegate
{
    private let ProjectListTableViewCellIdentifier = "ProjectListTableViewCellIdentifier"
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.keyboardDismissMode = .none
        tableView.alwaysBounceVertical = true
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    private lazy var emptyView = ProjectListEmptyView()
    
    
    // MARK: - Init
    override init(viewModel: ProjectListViewModel) {
        super.init(viewModel: viewModel)
        
        self.backgroundColor = Design.Colors.defaultBackground
        addSubview(tableView)
        addSubview(emptyView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ProjectListTableViewCell.self, forCellReuseIdentifier: ProjectListTableViewCellIdentifier)
        
        emptyView.onCreateProjectTap = { [weak self] in
            self?.viewModel.sendViewAction(.createProjectTap)
        }
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
        tableView.pin
            .top(pin.safeArea.top)
            .horizontally()
            .bottom()
        
        emptyView.pin.all()
        
        return frame.size
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: ProjectListViewState) {
        super.onState(state)
        
        emptyView.isHidden = !state.projects.isEmpty
        tableView.reloadData()
        setNeedsLayout()
    }
    
    override func onEffect(_ eff: ProjectListViewModel.Eff) {
        // Do nothing
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectListTableViewCellIdentifier) as! ProjectListTableViewCell
        let item = viewModel.state.projects[indexPath.row]
        cell.setViewItem(item)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.state.projects[indexPath.row]
        
        viewModel.sendViewAction(.projectTap(projectItem: item))
    }
}
