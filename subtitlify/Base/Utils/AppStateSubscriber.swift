//
//  AppStateSubscriber.swift
//  subtitlify
//
//  Created by Boris Bengus on 07/05/2024.
//

import Foundation
import UIKit

public struct AppStateSubscriberTokens {
    public let tokens: [NSObjectProtocol]
    
    public static let empty = AppStateSubscriberTokens(tokens: [])
}

public protocol AppStateSubscriber: AnyObject {
    var appStateTokens: AppStateSubscriberTokens { get set }
    func subscribeToAppState()
    func unsubscribeAppState()
    func appDidEnterBackground(_ app: UIApplication)
    func appWillEnterForeground(_ app: UIApplication)
}

public extension AppStateSubscriber {
    func subscribeToAppState() {
        var tokens = [NSObjectProtocol]()
        var token = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil, queue: nil) { [weak self] notification in
                if let app = notification.object as? UIApplication {
                    self?.appDidEnterBackground(app)
                }
            }
        tokens.append(token)
        token = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil, queue: nil) { [weak self] notification in
                if let app = notification.object as? UIApplication {
                    self?.appWillEnterForeground(app)
                }
            }
        tokens.append(token)
        appStateTokens = AppStateSubscriberTokens(tokens: tokens)
    }
    
    func unsubscribeAppState() {
        appStateTokens.tokens.forEach {
            NotificationCenter.default.removeObserver($0)
        }
        appStateTokens = .empty
    }
    
    
    func appDidEnterBackground(_ app: UIApplication) {
        //
    }
    
    func appWillEnterForeground(_ app: UIApplication) {
        //
    }
}
