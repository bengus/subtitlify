//
//  Buttons.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import UIKit

public enum Buttons {
    public static func image(
        image: UIImage?,
        backgroundColor: UIColor,
        cornerRadius: CGFloat = Design.Metrics.buttonCornerRadius,
        contentInsets: NSDirectionalEdgeInsets = Design.Metrics.buttonImageContentInset
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = contentInsets
        button.configuration = configuration
        
        return button
    }
    
    
    // MARK: - Solid(filled) buttons
    public static func solid(
        title: String? = nil,
        backgroundColor: UIColor,
        cornerRadius: CGFloat = Design.Metrics.buttonCornerRadius,
        contentInsets: NSDirectionalEdgeInsets = Design.Metrics.buttonSolidContentInset,
        font: UIFont,
        foregroundColor: UIColor
    ) -> UIButton {
        let button = UIButton(type: .custom)
        button.setTitle(title, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = contentInsets
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            outgoing.foregroundColor = foregroundColor
            return outgoing
        }
        button.configuration = configuration
        
        return button
    }
    
    public static func solidAccent(title: String? = nil) -> UIButton {
        return solid(
            title: title,
            backgroundColor: Design.Colors.accent,
            cornerRadius: Design.Metrics.buttonCornerRadius,
            contentInsets: Design.Metrics.buttonSolidContentInset,
            font: Design.Fonts.defaultButton,
            foregroundColor: Design.Colors.lightText
        )
    }
    
    public static func solidSecondary(title: String? = nil) -> UIButton {
        return solid(
            title: title,
            backgroundColor: Design.Colors.info,
            cornerRadius: Design.Metrics.buttonCornerRadius,
            contentInsets: Design.Metrics.buttonSolidContentInset,
            font: Design.Fonts.defaultButton,
            foregroundColor: Design.Colors.primaryText
        )
    }
    
    
    // MARK: - System(plain) buttons
    public static func system(
        title: String? = nil,
        contentInsets: NSDirectionalEdgeInsets = Design.Metrics.buttonSystemContentInset,
        font: UIFont = Design.Fonts.defaultText,
        foregroundColor: UIColor = Design.Colors.accent
    ) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = contentInsets
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = font
            outgoing.foregroundColor = foregroundColor
            return outgoing
        }
        button.configuration = configuration
        
        return button
    }
}
