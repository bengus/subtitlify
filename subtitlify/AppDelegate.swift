//
//  AppDelegate.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private lazy var di: AppContainerProtocol = AppContainer()
    
    
    // MARK: - UIApplicationDelegate
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        prepareApp()
        
        return true
    }
    
    
    // MARK: - Private
    private let launchTimer = SuperTimer(
        interval: 1.5,
        repeats: false
    )
    // Minimum time to present Launch screen is elapsed (to prevent LaunchScreen blinking if app is warmed-up)
    private var isLaunchTimerElapsed = false
    // If App correctly initialized
    private var isAppConfigured = false
    // App prepared to start UI
    private var isAppPrepared: Bool { return isLaunchTimerElapsed && isAppConfigured }
    
    private func prepareApp() {
        // Apply appearance from Design system
        Design.applyAppearance()
        // Reset badges
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        // Set RootContainer as rootViewController into window and present launch screen
        window?.rootViewController = di.rootContainerModule.containerViewController
        di.rootContainerModule.moduleInput.setRootContent(.launch)
        
        // Here could be all the initialization of the SDKs
        // Firebase
        // Intercom
        // Some other staff like that...
        
        // Check if app will configured first, or timer will elapsed first
        // In both cases perform app launch
        isLaunchTimerElapsed = false
        launchTimer.schedule { [weak self] in
            guard let self else { return }
            launchTimer.reset()
            isLaunchTimerElapsed = true
            performAppLaunchIfNeeded()
        }
        isAppConfigured = true
        performAppLaunchIfNeeded()
    }
    
    private func performAppLaunchIfNeeded() {
        guard isAppPrepared else { return }
        di.rootContainerModule.moduleInput.start()
    }
}
