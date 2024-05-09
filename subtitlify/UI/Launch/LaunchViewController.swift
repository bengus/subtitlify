//
//  LaunchViewController.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class LaunchViewController: BaseViewController {
    // MARK: - Subviews
    private lazy var loadingImageView: UIImageView = {
        let loadingImageView = UIImageView()
        loadingImageView.contentMode = .scaleAspectFit
        
        return loadingImageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = Design.Colors.loadingIndicatorWhite
        
        return activityIndicator
    }()
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Design.Colors.darkBackground
        loadingImageView.image = UIImage(named: "AppIcon")
        view.addSubview(loadingImageView)
        
        view.addSubview(activityIndicator)
        loadingImageView.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.loadingImageView.alpha = 1
            }, completion: { [weak self] _ in
                self?.activityIndicator.startAnimating()
            }
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingImageView.pin
            .vCenter()
            .hCenter()
            .width(Design.Metrics.logoWidth)
            .height(Design.Metrics.logoWidth)
        
        activityIndicator.pin
            .bottom(Design.Metrics.activityIndicatorBottomGap)
            .hCenter()
            .sizeToFit()
    }
}

private extension Design.Metrics {
    static let logoWidth: CGFloat = 200
    static let activityIndicatorBottomGap: CGFloat = 125
}
