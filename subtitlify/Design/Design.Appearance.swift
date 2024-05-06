//
//  Design.Appearance.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation
import UIKit

public extension Design {
    static func applyAppearance() {
        // NavigationBar
        let backImage = UIImage.maskedImageNamed("back", color: Design.Colors.navBarText)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().tintColor = Design.Colors.navBarText
        UINavigationBar.appearance().titleTextAttributes = [
            .font: Design.Fonts.navBarTitle,
            .foregroundColor: Design.Colors.navBarText
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                .font: Design.Fonts.navBarButton,
                .foregroundColor: Design.Colors.navBarText
            ],
            for: .normal
        )
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundColor = Design.Colors.navBarBackground
        navBarAppearance.titleTextAttributes = [
            .font: Design.Fonts.navBarTitle,
            .foregroundColor: Design.Colors.navBarText
        ]
        navBarAppearance.setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        let barButtonAppearance = UIBarButtonItemAppearance()
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Design.Fonts.navBarButton,
            .foregroundColor: Design.Colors.navBarText
        ]
        barButtonAppearance.normal.titleTextAttributes = attributes
        barButtonAppearance.highlighted.titleTextAttributes = attributes
        navBarAppearance.buttonAppearance = barButtonAppearance
        navBarAppearance.backButtonAppearance = barButtonAppearance
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = navBarAppearance
        }
        
        // TabBar
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                .font: Design.Fonts.tabBarTitle,
                .foregroundColor: Design.Colors.tabBarText
            ],
            for: .normal
        )
        UITabBarItem.appearance().setTitleTextAttributes(
            [
                .font: Design.Fonts.tabBarTitle,
                .foregroundColor: Design.Colors.tabBarSelectedText
            ],
            for: .selected
        )
        
        UITabBar.appearance().tintColor = Design.Colors.tabBarSelectedText
        UITabBar.appearance().unselectedItemTintColor = Design.Colors.tabBarText
        UITabBar.appearance().barTintColor = Design.Colors.tabBarBackround
        UITabBar.appearance().isTranslucent = false
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = Design.Colors.tabBarBackround
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITableView.appearance().sectionHeaderTopPadding = 0
        }
    }
}
