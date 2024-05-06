//
//  LoadingView.swift
//
//
//  Created by Boris Bengus on 27/01/2024.
//

import Foundation
import UIKit
import PinLayout

open class LoadingView: UIView {
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        
        return indicator
    }()
    
    
    // MARK: - Init
    public init(
        indicatorColor: UIColor,
        backdropColor: UIColor
    ) {
        super.init(frame: .zero)
        
        self.backgroundColor = backdropColor
        loadingIndicator.color = indicatorColor
        addSubview(loadingIndicator)
        self.isHidden = true
    }
    
    @available(*, unavailable, message: "Use another init()")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cycle
    open override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        self.pin.width(size.width)
        return layout()
    }
    
    open override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setNeedsLayout()
    }
    
    
    // MARK: - Loading
    open func setLoading(_ loading: Bool) {
        if loading {
            if let superview = superview {
                superview.bringSubviewToFront(self)
            }
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        self.isHidden = !loading
        self.setNeedsLayout()
    }
    
    
    // MARK: - Layout
    @discardableResult
    private func layout() -> CGSize {
        loadingIndicator.pin
            .hCenter()
            .vCenter()
        
        return frame.size
    }
}
