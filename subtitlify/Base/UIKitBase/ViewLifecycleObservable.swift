//
//  ViewLifecycleObservable.swift
//  subtitlify
//
//  Created by Boris Bengus on 06/05/2024.
//

import Foundation

public protocol ViewLifecycleObservable: AnyObject {
    var onViewDidLoad: (() -> ())? { get set }
    var onViewWillAppear: (() -> ())? { get set }
    var onViewDidAppear: (() -> ())? { get set }
    var onViewWillDisappear: (() -> ())? { get set }
    var onViewDidDisappear: (() -> ())? { get set }
    var onViewDidFirstAppear: (() -> ())? { get set }
    var onViewWillMoveToNilParent: (() -> ())? { get set }
    var onViewDidMoveToNilParent: (() -> ())? { get set }
}
