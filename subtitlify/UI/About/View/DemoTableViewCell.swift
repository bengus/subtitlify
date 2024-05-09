//
//  DemoListTableViewCell.swift
//  subtitlify
//
//  Created by Boris Bengus on 09/05/2024.
//

import Foundation
import UIKit
import PinLayout

final class DemoTableViewCell: UITableViewCell {
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Design.Metrics.cornerRadius
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.defaultText
        label.textColor = Design.Colors.primaryText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Design.Fonts.smallText
        label.textColor = Design.Colors.secondaryText
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = Design.Colors.border
        return view
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(previewImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(borderView)
    }
    
    @available(*, unavailable, message: "Use another init()")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Life cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)
        return layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        previewImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
    }
    
    // MARK: - Layout
    @discardableResult
    private func layout() -> CGSize {
        previewImageView.pin
            .top()
            .left()
            .marginTop(Design.Metrics.verticalGap)
            .marginLeft(Design.Metrics.horizontalGap)
            .width(Design.Metrics.imageWidth)
            .aspectRatio(1.5)
        
        titleLabel.pin
            .top()
            .marginTop(Design.Metrics.verticalGap)
            .after(of: previewImageView)
            .marginLeft(Design.Metrics.horizontalGap)
            .right()
            .marginRight(Design.Metrics.horizontalGap)
            .sizeToFit(.width)
        
        subtitleLabel.pin
            .below(of: titleLabel)
            .marginTop(Design.Metrics.smallVerticalGap)
            .after(of: previewImageView)
            .marginLeft(Design.Metrics.horizontalGap)
            .right()
            .marginRight(Design.Metrics.horizontalGap)
            .sizeToFit(.width)
        
        borderView.pin
            .below(of: [previewImageView, subtitleLabel])
            .marginTop(Design.Metrics.bigVerticalGap)
            .horizontally()
            .height(Design.Metrics.borderWidth)
        
        contentView.pin
            .width(100%)
            .height(borderView.frame.maxY)
        
        return contentView.frame.size
    }
    
    
    // MARK: - Configure ViewState
    func setViewItem(_ viewItem: AboutViewState.DemoItem) {
        previewImageView.image = viewItem.image
        titleLabel.text = viewItem.titleText
        subtitleLabel.text = viewItem.subtitleText
    }
}

private extension Design.Metrics {
    static let imageWidth: CGFloat = 150
    static let imageAspect: CGFloat = 1.5
}
