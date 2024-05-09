//
//  AboutView.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class AboutView: MvvmUIKitView
<
    AboutViewModel,
    AboutViewState,
    AboutViewModel.ViewAction,
    AboutViewModel.Eff
>,
    UITableViewDataSource,
    UITableViewDelegate
{
    private let DemoTableViewCellIdentifier = "DemoTableViewCellIdentifier"
    
    // MARK: - Subviews
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "AppIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Design.Metrics.cornerRadius
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.bold(ofSize: 24)
        label.textColor = Design.Colors.accent
        label.textAlignment = .center
        label.numberOfLines = 0
        if
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
        {
            label.text = "Subtitlify \(appVersion) (\(buildVersion))"
        } else {
            label.text = "Subtitlify"
        }
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.semibold(ofSize: 18)
        label.textColor = Design.Colors.primaryText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Demo show cases below:"
        return label
    }()
    
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
    
    
    // MARK: - Init
    override init(viewModel: AboutViewModel) {
        super.init(viewModel: viewModel)
        
        self.backgroundColor = Design.Colors.defaultBackground
        
        addSubview(logoImageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(tableView)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DemoTableViewCell.self, forCellReuseIdentifier: DemoTableViewCellIdentifier)
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
        logoImageView.pin
            .top(pin.safeArea.top)
            .marginTop(Design.Metrics.bigVerticalGap)
            .hCenter()
            .width(Design.Metrics.logoWidth)
            .height(Design.Metrics.logoWidth)
        
        titleLabel.pin
            .below(of: logoImageView)
            .marginTop(Design.Metrics.verticalGap)
            .horizontally(Design.Metrics.horizontalGap)
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel)
            .marginTop(Design.Metrics.bigVerticalGap)
            .horizontally(Design.Metrics.horizontalGap)
            .sizeToFit(.width)
        
        tableView.pin
            .below(of: subtitleLabel)
            .marginTop(Design.Metrics.smallVerticalGap)
            .horizontally()
            .bottom()
        
        return frame.size
    }
    
    
    // MARK: - State and effects
    override func onState(_ state: AboutViewState) {
        super.onState(state)
        
        tableView.reloadData()
        setNeedsLayout()
    }
    
    override func onEffect(_ eff: AboutViewModel.Eff) {
        // Do nothing
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.state.demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DemoTableViewCellIdentifier) as! DemoTableViewCell
        let item = viewModel.state.demos[indexPath.row]
        cell.setViewItem(item)
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.state.demos[indexPath.row]
        
        switch item.demoType {
        case .buffered:
            viewModel.sendViewAction(.demoBufferedTap)
        case .nonBuffered:
            viewModel.sendViewAction(.demoNonBufferedTap)
        }
    }
}

private extension Design.Metrics {
    static let logoWidth: CGFloat = 200
}
